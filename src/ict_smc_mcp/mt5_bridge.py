"""Read-only adapter for the official MetaTrader 5 Python API.

No trading methods are exposed. Rates are requested from position 1 by default,
which excludes the currently forming bar from the closed-bar analysis path.
"""
from __future__ import annotations

from contextlib import contextmanager
from collections.abc import Mapping
from datetime import datetime, timezone
from typing import Any, Iterator


MAX_RATE_COUNT = 5_000
_TIMEFRAMES = ("M1", "M2", "M3", "M4", "M5", "M6", "M10", "M12", "M15", "M20", "M30",
               "H1", "H2", "H3", "H4", "H6", "H8", "H12", "D1", "W1", "MN1")
_PUBLIC_SYMBOL_FIELDS = (
    "name", "description", "path", "digits", "point", "trade_tick_size",
    "trade_tick_value", "currency_base", "currency_profit", "visible", "trade_mode",
)


def normalize_count(value: Any, *, maximum: int = MAX_RATE_COUNT) -> int:
    """Return a bounded positive integer; reject bools and fractional values."""
    if isinstance(value, bool) or not isinstance(value, int) or value < 1:
        raise ValueError("count must be a positive integer")
    if maximum < 1:
        raise ValueError("maximum must be positive")
    return min(value, maximum)


def _field(value: Any, name: str, default: Any = None) -> Any:
    if isinstance(value, Mapping):
        return value.get(name, default)
    try:
        return value[name]
    except (KeyError, IndexError, TypeError, AttributeError):
        return getattr(value, name, default)


def _plain(value: Any) -> Any:
    """Convert NumPy scalar-like MT5 values to JSON-friendly builtins."""
    if hasattr(value, "item"):
        try:
            value = value.item()
        except (ValueError, TypeError):
            pass
    if isinstance(value, (str, int, float, bool)) or value is None:
        return value
    return str(value)


class ReadOnlyMT5:
    """Small read-only facade over MetaTrader5; accepts a fake API for tests."""

    def __init__(self, api: Any):
        self._api = api

    @contextmanager
    def _session(self) -> Iterator[None]:
        if not self._api.initialize():
            error = self._api.last_error()
            raise RuntimeError(f"MetaTrader 5 initialize failed: {error}")
        try:
            yield
        finally:
            self._api.shutdown()

    def status(self) -> dict[str, Any]:
        with self._session():
            info = self._api.terminal_info()
            version = self._api.version()
            return {
                "connected": bool(_field(info, "connected", False)),
                "version": [_plain(part) for part in version] if version else None,
            }

    def list_symbols(self, *, query: str = "", limit: int = 100) -> dict[str, Any]:
        if not isinstance(query, str):
            raise ValueError("query must be a string")
        limit = normalize_count(limit, maximum=1_000)
        needle = query.strip().casefold()
        with self._session():
            symbols = self._api.symbols_get()
            if symbols is None:
                raise RuntimeError(f"symbols_get failed: {self._api.last_error()}")
            found: list[dict[str, Any]] = []
            for symbol in symbols:
                row = {
                    key: _plain(_field(symbol, key))
                    for key in _PUBLIC_SYMBOL_FIELDS
                    if _field(symbol, key) is not None
                }
                searchable = " ".join(str(row.get(key, "")) for key in ("name", "description", "path"))
                if not needle or needle in searchable.casefold():
                    found.append(row)
                    if len(found) >= limit:
                        break
            return {"count": len(found), "limit": limit, "symbols": found}

    def symbol_info(self, symbol: str) -> dict[str, Any]:
        if not isinstance(symbol, str) or not symbol.strip():
            raise ValueError("symbol must be a non-empty string")
        with self._session():
            info = self._api.symbol_info(symbol.strip())
            if info is None:
                raise RuntimeError(f"symbol_info returned no result for {symbol!r}: {self._api.last_error()}")
            return {
                key: _plain(_field(info, key))
                for key in _PUBLIC_SYMBOL_FIELDS
                if _field(info, key) is not None
            }

    def rates(self, symbol: str, timeframe: str, count: int) -> dict[str, Any]:
        if not isinstance(symbol, str) or not symbol.strip():
            raise ValueError("symbol must be a non-empty string")
        if not isinstance(timeframe, str) or timeframe not in _TIMEFRAMES:
            raise ValueError(f"unsupported timeframe; choose one of: {', '.join(_TIMEFRAMES)}")
        bounded_count = normalize_count(count)
        constant_name = f"TIMEFRAME_{timeframe}"
        mt5_timeframe = getattr(self._api, constant_name, None)
        if mt5_timeframe is None:
            raise ValueError(f"timeframe {timeframe} is not supported by this MetaTrader 5 API build")

        with self._session():
            # start_pos=1 excludes the in-progress bar (position 0).
            rates = self._api.copy_rates_from_pos(symbol.strip(), mt5_timeframe, 1, bounded_count)
            if rates is None:
                raise RuntimeError(f"copy_rates_from_pos failed: {self._api.last_error()}")
            rows: list[dict[str, Any]] = []
            for rate in rates:
                epoch = int(_field(rate, "time"))
                row = {
                    "time": datetime.fromtimestamp(epoch, tz=timezone.utc).isoformat().replace("+00:00", "Z"),
                    "open": float(_field(rate, "open")),
                    "high": float(_field(rate, "high")),
                    "low": float(_field(rate, "low")),
                    "close": float(_field(rate, "close")),
                    "tick_volume": int(_field(rate, "tick_volume", 0) or 0),
                    "spread": int(_field(rate, "spread", 0) or 0),
                    "real_volume": int(_field(rate, "real_volume", 0) or 0),
                }
                rows.append(row)
            return {
                "symbol": symbol.strip(),
                "timeframe": timeframe,
                "requested_count": bounded_count,
                "returned_count": len(rows),
                "closed_only": True,
                "start_pos": 1,
                "bars": rows,
            }
