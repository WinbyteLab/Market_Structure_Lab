from __future__ import annotations

import argparse
import asyncio
import csv
import json
import sys
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
SCRIPTS_DIR = ROOT / "scripts"
CATALOG_PATH = ROOT / "catalog" / "ict_smc_catalog.json"
REPORTS_DIR = ROOT / "reports"

# These are event counts from the existing tested Python reference engine.
# They are not MQL5 runtime detections and are never presented as such.
REFERENCE_EVENT_MAP: dict[str, tuple[str, ...]] = {
    "C001": ("SWING_HIGH_CONFIRMED", "SWING_LOW_CONFIRMED"),
    "C004": ("SWING_HIGH_CONFIRMED", "SWING_LOW_CONFIRMED"),
    "C007": ("BOS_UP", "BOS_DOWN"),
    "C009": ("MSS_UP", "MSS_DOWN"),
    "C024": ("BUY_SIDE_SWEEP", "SELL_SIDE_SWEEP"),
    "C042": ("FVG_BULLISH", "FVG_BEARISH"),
    "C043": ("FVG_BULLISH",),
    "C044": ("FVG_BEARISH",),
    "C052": ("OB_BULL_PROXY", "OB_BEAR_PROXY"),
}
MQL5_PRIMITIVE_ONLY_IDS = {"C001", "C002", "C004", "C007", "C024", "C042", "C043", "C044"}
CSV_FIELDS = (
    "candidate_id",
    "term_en",
    "term_ru",
    "family",
    "type",
    "origin",
    "source_refs",
    "coverage_status",
    "reference_event_types",
    "reference_event_count",
    "mql5_status",
    "note",
)


def _nonautomatic_status(record: dict[str, Any]) -> tuple[str, str]:
    family = str(record.get("family", ""))
    kind = str(record.get("type", ""))
    origin = str(record.get("origin", "")).casefold()
    status = str(record.get("status", "")).casefold()
    if kind == "external-data-filter":
        return "EXTERNAL_DATA_REQUIRED", "Requires an external, time-aligned data source."
    if family == "combination":
        return "COMBINATION_NOT_IMPLEMENTED", "Needs tested component detectors and a versioned composition rule."
    if "interpretive" in kind or family in {"context", "order-flow", "risk/context"}:
        return "CONTEXT_ONLY", "OHLC alone does not establish actor intent or a canonical directional state."
    if "discovery-only" in status or "community-only" in status or "community" in origin:
        return "MANUAL_REVIEW", "Attribution or operational definition is not yet primary-source verified."
    return "NOT_IMPLEMENTED", "No candidate-specific detector has been implemented and tested yet."


def build_coverage_rows(records: list[dict[str, Any]], event_counts: dict[str, int]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for record in records:
        candidate_id = str(record["id"])
        event_types = REFERENCE_EVENT_MAP.get(candidate_id, ())
        available_types = tuple(name for name in event_types if name in event_counts)
        reference_count: int | None = None
        if available_types:
            reference_count = sum(int(event_counts[name]) for name in available_types)
            coverage_status = "REFERENCE_EVENTS_AVAILABLE_NOT_MQL5_RUNTIME"
            note = "Count comes from Python/MCP reference analysis; not a result of the MQL5 detector."
        elif event_types:
            coverage_status = "REFERENCE_EVENT_TYPES_NOT_REPORTED"
            note = "The reference engine did not return these event types; this is not evidence of zero events."
        else:
            coverage_status, note = _nonautomatic_status(record)

        if candidate_id in MQL5_PRIMITIVE_ONLY_IDS:
            mql5_status = "PRIMITIVE_ONLY_NOT_FULL_CANDIDATE_DETECTOR"
        elif candidate_id in REFERENCE_EVENT_MAP:
            mql5_status = "PYTHON_REFERENCE_ONLY"
        else:
            mql5_status = "NO_MQL5_DETECTOR"

        rows.append(
            {
                "candidate_id": candidate_id,
                "term_en": record["term_en"],
                "term_ru": record["term_ru"],
                "family": record["family"],
                "type": record["type"],
                "origin": record["origin"],
                "source_refs": ",".join(str(value) for value in record.get("source_refs", [])),
                "coverage_status": coverage_status,
                "reference_event_types": ",".join(available_types),
                "reference_event_count": reference_count,
                "mql5_status": mql5_status,
                "note": note,
            }
        )
    return rows


def write_reports(report: dict[str, Any], rows: list[dict[str, Any]]) -> tuple[Path, Path]:
    REPORTS_DIR.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    csv_path = REPORTS_DIR / f"ict_smc_1000bar_coverage_{stamp}.csv"
    json_path = REPORTS_DIR / f"ict_smc_1000bar_coverage_{stamp}.json"
    status_counts = dict(Counter(row["coverage_status"] for row in rows))
    output = {
        "checked_at_utc": report["checked_at_utc"],
        "market": report["market"],
        "mcp_status": report["mt5_status"],
        "mcp_order_tools_present": report["order_tools_present"],
        "catalog_record_count": len(rows),
        "coverage_status_counts": status_counts,
        "reference_event_counts": report["analysis"]["event_counts"],
        "reference_engine_assumptions": report["analysis"]["assumptions"],
        "limitations": [
            "A 126-row coverage report is not 126 completed detectors.",
            "Only event types returned by the existing Python reference engine have event counts.",
            "MQL5 primitive-only, manual, external-data and unimplemented entries are reported distinctly.",
            "Missing event types are null, not zero.",
        ],
        "rows": rows,
    }
    with csv_path.open("x", newline="", encoding="utf-8-sig") as stream:
        writer = csv.DictWriter(stream, fieldnames=CSV_FIELDS)
        writer.writeheader()
        writer.writerows(rows)
    with json_path.open("x", encoding="utf-8") as stream:
        json.dump(output, stream, ensure_ascii=False, indent=2)
        stream.write("\n")
    return csv_path, json_path


async def _run_mcp(symbol_query: str, timeframe: str, count: int) -> dict[str, Any]:
    sys.path.insert(0, str(SCRIPTS_DIR))
    import smoke_mcp_readonly

    return await smoke_mcp_readonly.run(symbol_query, timeframe, count)


def main() -> int:
    parser = argparse.ArgumentParser(description="Read 1000 closed MT5 bars and produce an honest coverage row for every catalog candidate.")
    parser.add_argument("--symbol-query", default="EURUSD")
    parser.add_argument("--timeframe", default="M15")
    parser.add_argument("--count", type=int, default=1000)
    args = parser.parse_args()
    if args.count != 1000:
        parser.error("this acceptance run is fixed at exactly 1000 closed bars")

    catalog = json.loads(CATALOG_PATH.read_text(encoding="utf-8"))
    report = asyncio.run(_run_mcp(args.symbol_query, args.timeframe, args.count))
    if report["market"]["returned_bar_count"] != 1000 or not report["market"]["closed_bars_only"]:
        raise RuntimeError("MCP did not return exactly 1000 closed bars")
    rows = build_coverage_rows(catalog["records"], report["analysis"]["event_counts"])
    if len(rows) != catalog["record_count"]:
        raise RuntimeError("coverage output does not include every catalog row")
    csv_path, json_path = write_reports(report, rows)
    print(json.dumps({
        "mcp_connected": report["mt5_status"].get("connected"),
        "symbol": report["market"]["symbol"],
        "timeframe": report["market"]["timeframe"],
        "closed_bars": report["market"]["returned_bar_count"],
        "candidate_rows": len(rows),
        "status_counts": dict(Counter(row["coverage_status"] for row in rows)),
        "csv": str(csv_path),
        "json": str(json_path),
        "orders_tool_present": report["order_tools_present"],
    }, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
