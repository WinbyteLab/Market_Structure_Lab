"""Application service shared by MCP tools and integration tests."""
from __future__ import annotations

from typing import Any

from .engine import analyze_bars


class ResearchService:
    """Validate MT5 provenance and run deterministic event analysis."""

    def __init__(self, bridge: Any):
        self._bridge = bridge

    def analyze_market(
        self,
        symbol: str,
        timeframe: str,
        count: int,
        *,
        left: int = 2,
        right: int = 2,
        min_fvg_gap: float = 0.0,
        ob_lookback: int = 10,
    ) -> dict[str, Any]:
        if not isinstance(symbol, str) or not symbol.strip():
            raise ValueError("symbol must be a non-empty string")
        if not isinstance(timeframe, str) or not timeframe.strip():
            raise ValueError("timeframe must be a non-empty string")

        requested_symbol = symbol.strip()
        requested_timeframe = timeframe.strip()
        payload = self._bridge.rates(requested_symbol, requested_timeframe, count)
        if not isinstance(payload, dict):
            raise ValueError("market-data adapter returned an invalid payload")
        if payload.get("closed_only") is not True or payload.get("start_pos") != 1:
            raise ValueError("analysis requires closed bars only; forming-bar data is not accepted")
        if payload.get("symbol") != requested_symbol:
            raise ValueError("returned market symbol does not match the requested symbol")
        if payload.get("timeframe") != requested_timeframe:
            raise ValueError("returned timeframe does not match the requested timeframe")
        bars = payload.get("bars")
        if not isinstance(bars, list):
            raise ValueError("market-data adapter returned no bar list")

        analysis = analyze_bars(
            bars,
            left=left,
            right=right,
            min_fvg_gap=min_fvg_gap,
            ob_lookback=ob_lookback,
        )
        return {
            "market": {
                "source": "local MetaTrader 5 terminal via read-only adapter",
                "symbol": requested_symbol,
                "timeframe": requested_timeframe,
                "closed_bars_only": True,
                "start_pos": 1,
                "requested_bars": payload.get("requested_count", count),
                "returned_bars": len(bars),
            },
            "bar_count": analysis["bar_count"],
            "event_counts": analysis["event_counts"],
            "events": analysis["events"],
            "assumptions": analysis["assumptions"],
            "warnings": analysis["warnings"],
        }
