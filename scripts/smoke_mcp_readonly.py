"""Opt-in read-only smoke test through this project's MCP stdio server.

It requests only terminal status, symbols, closed OHLC rates, analysis, and a
project-local CSV export. It never requests account info or trading tools.
"""
from __future__ import annotations

import argparse
import asyncio
import json
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from mcp import ClientSession
from mcp.client.stdio import StdioServerParameters, stdio_client

PROJECT_ROOT = Path(__file__).resolve().parents[1]


def _payload(result: Any) -> dict[str, Any]:
    if getattr(result, "isError", False):
        raise RuntimeError(str(getattr(result, "content", "MCP tool call failed")))
    structured = getattr(result, "structuredContent", None)
    if isinstance(structured, dict):
        return structured
    for item in getattr(result, "content", []) or []:
        text = getattr(item, "text", None)
        if text:
            parsed = json.loads(text)
            if isinstance(parsed, dict):
                return parsed
    raise RuntimeError("MCP returned no structured JSON content")


async def run(symbol_query: str, timeframe: str, count: int) -> dict[str, Any]:
    params = StdioServerParameters(command=sys.executable, args=["-m", "ict_smc_mcp.server"])
    async with stdio_client(params) as (read_stream, write_stream):
        async with ClientSession(read_stream, write_stream) as session:
            initialized = await session.initialize()
            tools = await session.list_tools()
            tool_names = {tool.name for tool in tools.tools}
            required = {"mt5_status", "list_symbols", "get_rates", "analyze_market", "export_rates_csv"}
            if not required.issubset(tool_names):
                raise RuntimeError(f"MCP tool inventory is incomplete: missing {sorted(required - tool_names)}")

            status = _payload(await session.call_tool("mt5_status", {}))
            found = _payload(await session.call_tool("list_symbols", {"query": symbol_query, "limit": 50}))
            symbols = found.get("symbols", [])
            if not symbols:
                raise RuntimeError(f"MT5 returned no symbols matching {symbol_query!r}")
            symbol = next(
                (item["name"] for item in symbols if symbol_query.casefold() in item.get("name", "").casefold()),
                symbols[0]["name"],
            )
            rates = _payload(await session.call_tool("get_rates", {
                "symbol": symbol, "timeframe": timeframe, "count": count,
            }))
            if rates.get("closed_only") is not True or rates.get("start_pos") != 1:
                raise RuntimeError("MCP did not enforce closed-bar-only retrieval")
            bars = rates.get("bars", [])
            if not bars:
                raise RuntimeError(f"MT5 returned no bars for {symbol} {timeframe}")
            analysis = _payload(await session.call_tool("analyze_market", {
                "symbol": symbol, "timeframe": timeframe, "count": count,
                "left": 2, "right": 2, "min_fvg_gap": 0.0, "ob_lookback": 10,
            }))
            export = _payload(await session.call_tool("export_rates_csv", {
                "symbol": symbol, "timeframe": timeframe, "count": count,
            }))
            report = {
                "checked_at_utc": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
                "mcp_server": getattr(initialized, "serverInfo", None).name if getattr(initialized, "serverInfo", None) else "ict-smc-research",
                "mt5_status": status,
                "market": {
                    "source": "connected local MetaTrader 5 terminal; provider/server identity is intentionally not queried",
                    "symbol": symbol,
                    "timeframe": timeframe,
                    "returned_bar_count": len(bars),
                    "first_bar_utc": bars[0]["time"],
                    "last_bar_utc": bars[-1]["time"],
                    "last_close": bars[-1]["close"],
                    "closed_bars_only": rates["closed_only"],
                },
                "analysis": {
                    "bar_count": analysis["bar_count"],
                    "event_counts": analysis["event_counts"],
                    "warnings": analysis["warnings"],
                    "assumptions": analysis["assumptions"],
                },
                "export": export,
                "available_tool_names": sorted(tool_names),
                "order_tools_present": any("order" in name.casefold() for name in tool_names),
            }
            return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--symbol-query", default="EURUSD")
    parser.add_argument("--timeframe", default="M15")
    parser.add_argument("--count", type=int, default=500)
    args = parser.parse_args()
    report = asyncio.run(run(args.symbol_query, args.timeframe, args.count))
    output = PROJECT_ROOT / "reports" / "mt5_mcp_smoke.json"
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, ensure_ascii=False, indent=2))
    print(f"Saved: {output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
