from __future__ import annotations

import argparse
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CATALOG_PATH = ROOT / "catalog" / "ict_smc_catalog.json"
OUTPUT_PATH = ROOT / "include" / "SMC_ICT_Library.mqh"

# Only rules implemented in this first MQL5 slice are marked as primitives.
PRIMITIVE_IDS = {
    "C001",  # confirmed pivots / basic structure
    "C002",  # HH/HL vs LH/LL state primitives
    "C004",  # short-term swing primitive
    "C007",  # close-break primitive
    "C024",  # close-back liquidity sweep
    "C042",  # three-bar FVG
    "C043",  # bullish FVG alias
    "C044",  # bearish FVG alias
}


def _mql_string(value: str) -> str:
    safe = value.replace("\\", "\\\\").replace('"', '\\"')
    safe = safe.replace("\r", " ").replace("\n", " ")
    return f'"{safe}"'


def _support(record: dict[str, object]) -> str:
    candidate_id = str(record["id"])
    if candidate_id in PRIMITIVE_IDS:
        return "SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE"
    if record["family"] == "combination":
        return "SMC_ICT_SUPPORT_COMBINATION"
    if record["type"] == "external-data-filter":
        return "SMC_ICT_SUPPORT_EXTERNAL_DATA"
    origin = str(record["origin"]).casefold()
    status = str(record["status"]).casefold()
    if "discovery-only" in status or "community-only" in status or "community candidate" in origin:
        return "SMC_ICT_SUPPORT_MANUAL_REVIEW"
    if "interpretive" in str(record["type"]).casefold() or record["family"] in {"context", "order-flow", "risk/context"}:
        return "SMC_ICT_SUPPORT_CONTEXT_ONLY"
    return "SMC_ICT_SUPPORT_NOT_FORMALIZED"


def render_header(catalog: dict[str, object]) -> str:
    records = catalog["records"]
    if not isinstance(records, list) or len(records) != catalog["record_count"]:
        raise ValueError("catalog record_count does not match records")

    expected_ids = [f"C{i:03d}" for i in range(1, len(records) + 1)]
    actual_ids = [str(record["id"]) for record in records]
    if actual_ids != expected_ids:
        raise ValueError("catalog IDs must be sequential C001..Cn")

    lines = [
        "#ifndef SMC_ICT_LIBRARY_MQH",
        "#define SMC_ICT_LIBRARY_MQH",
        "",
        "// Generated from catalog/ict_smc_catalog.json by scripts/generate_mql5_library.py.",
        "// Do not treat registry presence as proof that an item is automatically detectable.",
        "// All bars passed to the detector functions must be ordered oldest to newest.",
        f'#define SMC_ICT_CATALOG_VERSION {_mql_string(str(catalog["catalog_id"]))}',
        f'#define SMC_ICT_CATALOG_COUNT {len(records)}',
        "",
        "enum ENUM_SMC_ICT_ID",
        "{",
    ]
    for index, record in enumerate(records):
        comma = "," if index < len(records) - 1 else ""
        lines.append(f'   SMC_ICT_{record["id"]} = {index + 1}{comma}')
    lines.extend(
        [
            "};",
            "",
            "enum ENUM_SMC_ICT_SUPPORT",
            "{",
            "   SMC_ICT_SUPPORT_NOT_FORMALIZED = 0,",
            "   SMC_ICT_SUPPORT_CONTEXT_ONLY = 1,",
            "   SMC_ICT_SUPPORT_EXTERNAL_DATA = 2,",
            "   SMC_ICT_SUPPORT_MANUAL_REVIEW = 3,",
            "   SMC_ICT_SUPPORT_COMBINATION = 4,",
            "   SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE = 5",
            "};",
            "",
            "enum ENUM_SMC_ICT_DIRECTION",
            "{",
            "   SMC_ICT_DIRECTION_BEARISH = -1,",
            "   SMC_ICT_DIRECTION_NONE = 0,",
            "   SMC_ICT_DIRECTION_BULLISH = 1",
            "};",
            "",
            "enum ENUM_SMC_ICT_SWEEP_SIDE",
            "{",
            "   SMC_ICT_SWEEP_SELL_SIDE = -1, // Low is swept; close returns above the level.",
            "   SMC_ICT_SWEEP_BUY_SIDE = 1    // High is swept; close returns below the level.",
            "};",
            "",
            "struct SMC_ICT_Definition",
            "{",
            "   ENUM_SMC_ICT_ID id;",
            "   string code;",
            "   string term_en;",
            "   string term_ru;",
            "   string family;",
            "   string kind;",
            "   string origin;",
            "   string status;",
            "   string code_status;",
            "   string source_refs;",
            "   ENUM_SMC_ICT_SUPPORT support;",
            "};",
            "",
            "int SMC_ICT_CandidateCount()",
            "{",
            "   return SMC_ICT_CATALOG_COUNT;",
            "}",
            "",
            "bool SMC_ICT_GetDefinition(const ENUM_SMC_ICT_ID candidate_id, SMC_ICT_Definition &out)",
            "{",
            "   switch(candidate_id)",
            "   {",
        ]
    )

    for record in records:
        candidate_id = str(record["id"])
        refs = ",".join(str(value) for value in record["source_refs"])
        lines.extend(
            [
                f"      case SMC_ICT_{candidate_id}:",
                f"         out.id = SMC_ICT_{candidate_id};",
                f"         out.code = {_mql_string(candidate_id)};",
                f"         out.term_en = {_mql_string(str(record['term_en']))};",
                f"         out.term_ru = {_mql_string(str(record['term_ru']))};",
                f"         out.family = {_mql_string(str(record['family']))};",
                f"         out.kind = {_mql_string(str(record['type']))};",
                f"         out.origin = {_mql_string(str(record['origin']))};",
                f"         out.status = {_mql_string(str(record['status']))};",
                f"         out.code_status = {_mql_string(str(record['code_status']))};",
                f"         out.source_refs = {_mql_string(refs)};",
                f"         out.support = {_support(record)};",
                "         return true;",
            ]
        )
    lines.extend(["   }", "   return false;", "}", ""])

    lines.extend(
        [
            "// OHLC validation used by the deterministic primitives below.",
            "bool SMC_ICT_IsValidBar(const MqlRates &bar)",
            "{",
            "   if(bar.high < bar.low) return false;",
            "   if(bar.open < bar.low || bar.open > bar.high) return false;",
            "   if(bar.close < bar.low || bar.close > bar.high) return false;",
            "   return true;",
            "}",
            "",
            "// Three chronological closed bars: bar1 is oldest, bar3 is newest.",
            "// Outputs are valid only when the function returns true.",
            "bool SMC_ICT_IsBullishFVG(const MqlRates &bar1, const MqlRates &bar2, const MqlRates &bar3, double &gap_low, double &gap_high)",
            "{",
            "   gap_low = 0.0;",
            "   gap_high = 0.0;",
            "   if(!SMC_ICT_IsValidBar(bar1) || !SMC_ICT_IsValidBar(bar2) || !SMC_ICT_IsValidBar(bar3)) return false;",
            "   if(bar3.low <= bar1.high) return false;",
            "   gap_low = bar1.high;",
            "   gap_high = bar3.low;",
            "   return true;",
            "}",
            "",
            "bool SMC_ICT_IsBearishFVG(const MqlRates &bar1, const MqlRates &bar2, const MqlRates &bar3, double &gap_low, double &gap_high)",
            "{",
            "   gap_low = 0.0;",
            "   gap_high = 0.0;",
            "   if(!SMC_ICT_IsValidBar(bar1) || !SMC_ICT_IsValidBar(bar2) || !SMC_ICT_IsValidBar(bar3)) return false;",
            "   if(bar3.high >= bar1.low) return false;",
            "   gap_low = bar3.high;",
            "   gap_high = bar1.low;",
            "   return true;",
            "}",
            "",
            "bool SMC_ICT_IsCloseBreak(const double close_price, const double reference_level, const ENUM_SMC_ICT_DIRECTION direction)",
            "{",
            "   if(direction == SMC_ICT_DIRECTION_BULLISH) return close_price > reference_level;",
            "   if(direction == SMC_ICT_DIRECTION_BEARISH) return close_price < reference_level;",
            "   return false;",
            "}",
            "",
            "// Buy-side sweep: high pierces level and close returns below. Sell-side is mirrored.",
            "bool SMC_ICT_IsLiquiditySweep(const MqlRates &bar, const double reference_level, const ENUM_SMC_ICT_SWEEP_SIDE side)",
            "{",
            "   if(!SMC_ICT_IsValidBar(bar)) return false;",
            "   if(side == SMC_ICT_SWEEP_BUY_SIDE) return (bar.high > reference_level && bar.close < reference_level);",
            "   if(side == SMC_ICT_SWEEP_SELL_SIDE) return (bar.low < reference_level && bar.close > reference_level);",
            "   return false;",
            "}",
            "",
            "// Rates must be chronological oldest->newest. A pivot is unavailable until right_bars exist.",
            "// Strict comparisons intentionally reject ties; caller should plot only after confirmation.",
            "bool SMC_ICT_IsConfirmedSwingHigh(const MqlRates &rates[], const int index, const int left_bars, const int right_bars, double &price)",
            "{",
            "   price = 0.0;",
            "   const int total = ArraySize(rates);",
            "   if(left_bars < 1 || right_bars < 1 || index < left_bars || index + right_bars >= total) return false;",
            "   for(int i = index - left_bars; i <= index + right_bars; ++i)",
            "   {",
            "      if(i == index) continue;",
            "      if(rates[i].high >= rates[index].high) return false;",
            "   }",
            "   price = rates[index].high;",
            "   return true;",
            "}",
            "",
            "bool SMC_ICT_IsConfirmedSwingLow(const MqlRates &rates[], const int index, const int left_bars, const int right_bars, double &price)",
            "{",
            "   price = 0.0;",
            "   const int total = ArraySize(rates);",
            "   if(left_bars < 1 || right_bars < 1 || index < left_bars || index + right_bars >= total) return false;",
            "   for(int i = index - left_bars; i <= index + right_bars; ++i)",
            "   {",
            "      if(i == index) continue;",
            "      if(rates[i].low <= rates[index].low) return false;",
            "   }",
            "   price = rates[index].low;",
            "   return true;",
            "}",
            "",
            "#endif // SMC_ICT_LIBRARY_MQH",
            "",
        ]
    )
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate the MQL5 ICT/SMC registry and deterministic primitives.")
    parser.add_argument("--check", action="store_true", help="fail if the checked-in header differs from the catalog")
    args = parser.parse_args()

    catalog = json.loads(CATALOG_PATH.read_text(encoding="utf-8"))
    generated = render_header(catalog)
    if args.check:
        if not OUTPUT_PATH.is_file():
            raise SystemExit("MQL5 header is missing; run this generator without --check")
        existing = OUTPUT_PATH.read_text(encoding="utf-8-sig")
        if existing != generated:
            raise SystemExit("MQL5 header is stale; regenerate it from the catalog")
        print(f"up to date: {OUTPUT_PATH} ({len(catalog['records'])} candidates)")
        return 0

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_PATH.write_text(generated, encoding="utf-8-sig", newline="\n")
    print(f"generated: {OUTPUT_PATH} ({len(catalog['records'])} candidates)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
