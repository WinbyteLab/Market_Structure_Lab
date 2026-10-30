"""Read-only MCP server exposing local MT5 market data and ICT/SMC analysis."""
from __future__ import annotations

import csv
import re
from datetime import datetime, timezone
from pathlib import Path
from typing import Any
from uuid import uuid4

from mcp.server.fastmcp import FastMCP

from .mt5_bridge import ReadOnlyMT5
from .service import ResearchService


PROJECT_ROOT = Path(__file__).resolve().parents[2]


def _default_bridge() -> ReadOnlyMT5:
    try:
        import MetaTrader5 as mt5
    except ImportError as exc:
        raise RuntimeError(
            "MetaTrader5 Python package is missing; install the project's [mt5] extra in .venv"
        ) from exc
    return ReadOnlyMT5(mt5)


def _safe_segment(value: str) -> str:
    safe = re.sub(r"[^A-Za-z0-9_-]+", "_", value.strip()).strip("_")
    if not safe or safe in {".", ".."}:
        raise ValueError("symbol/timeframe cannot be used as an export name")
    return safe[:48]


def _write_csv(project_root: Path, payload: dict[str, Any]) -> dict[str, Any]:
    data_root = (project_root / "data" / "raw").resolve()
    project_root = project_root.resolve()
    if project_root not in data_root.parents:
        raise ValueError("export directory must remain inside the project folder")
    data_root.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
    suffix = uuid4().hex[:8]
    name = f"mt5_{_safe_segment(payload['symbol'])}_{_safe_segment(payload['timeframe'])}_{stamp}_{suffix}.csv"
    target = (data_root / name).resolve()
    if data_root not in target.parents:
        raise ValueError("export path escaped the project data directory")
    fields = ("time", "open", "high", "low", "close", "tick_volume", "spread", "real_volume")
    with target.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(payload["bars"])
    return {
        "relative_path": target.relative_to(project_root).as_posix(),
        "bar_count": len(payload["bars"]),
        "symbol": payload["symbol"],
        "timeframe": payload["timeframe"],
        "closed_bars_only": payload["closed_only"],
    }


def create_server(bridge: Any | None = None, project_root: Path | None = None) -> FastMCP:
    """Build an MCP server. Inject a fake bridge only in isolated tests."""
    adapter = bridge if bridge is not None else _default_bridge()
    service = ResearchService(adapter)
    root = Path(project_root) if project_root is not None else PROJECT_ROOT
    server = FastMCP(
        "ict-smc-research",
        instructions=(
            "Read-only ICT/SMC research. Tools retrieve closed MetaTrader 5 bars, "
            "describe market data, and calculate deterministic chart events. "
            "No tool places, modifies, or closes a trade. MCP outputs are research "
            "data, not financial advice."
        ),
    )

    @server.tool(description="Check local MT5 connectivity/version only; account identifiers are not returned.")
    def mt5_status() -> dict[str, Any]:
        return adapter.status()

    @server.tool(description="Search visible/invisible symbols with a bounded result count.")
    def list_symbols(query: str = "", limit: int = 100) -> dict[str, Any]:
        return adapter.list_symbols(query=query, limit=limit)

    @server.tool(description="Read public instrument metadata; account fields are excluded.")
    def symbol_info(symbol: str) -> dict[str, Any]:
        return adapter.symbol_info(symbol)

    @server.tool(description="Fetch closed OHLC bars only. The forming bar is excluded; count is capped at 5000.")
    def get_rates(symbol: str, timeframe: str, count: int = 500) -> dict[str, Any]:
        return adapter.rates(symbol, timeframe, count)

    @server.tool(description="Detect explicitly operational ICT/SMC-inspired chart events on closed bars.")
    def analyze_market(
        symbol: str,
        timeframe: str,
        count: int = 500,
        left: int = 2,
        right: int = 2,
        min_fvg_gap: float = 0.0,
        ob_lookback: int = 10,
    ) -> dict[str, Any]:
        return service.analyze_market(
            symbol,
            timeframe,
            count,
            left=left,
            right=right,
            min_fvg_gap=min_fvg_gap,
            ob_lookback=ob_lookback,
        )

    @server.tool(description="Export closed MT5 bars to a timestamped CSV inside the project data/raw directory.")
    def export_rates_csv(symbol: str, timeframe: str, count: int = 500) -> dict[str, Any]:
        payload = adapter.rates(symbol, timeframe, count)
        return _write_csv(root, payload)

    return server


def main() -> None:
    create_server().run(transport="stdio")


if __name__ == "__main__":
    main()
