from __future__ import annotations

import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CATALOG = ROOT / "catalog" / "ict_smc_catalog.json"
HEADER = ROOT / "include" / "SMC_ICT_Library.mqh"


def _case_body(source: str, candidate_id: str) -> str:
    marker = f"case SMC_ICT_{candidate_id}:"
    assert marker in source, f"missing switch case for {candidate_id}"
    return source.split(marker, 1)[1].split("return true;", 1)[0]


def test_mql5_library_registers_every_catalog_candidate() -> None:
    catalog = json.loads(CATALOG.read_text(encoding="utf-8"))
    assert HEADER.is_file(), "MQL5 include library has not been generated"
    source = HEADER.read_text(encoding="utf-8")

    assert "#define SMC_ICT_CATALOG_COUNT 126" in source
    for record in catalog["records"]:
        candidate_id = record["id"]
        enum_name = f"SMC_ICT_{candidate_id}"
        assert re.search(rf"\b{enum_name}\s*=\s*\d+", source), candidate_id
        assert f"case {enum_name}:" in source, candidate_id


def test_mql5_library_exposes_deterministic_base_detectors() -> None:
    assert HEADER.is_file(), "MQL5 include library has not been generated"
    source = HEADER.read_text(encoding="utf-8")
    for function_name in (
        "SMC_ICT_IsBullishFVG",
        "SMC_ICT_IsBearishFVG",
        "SMC_ICT_IsLiquiditySweep",
        "SMC_ICT_IsCloseBreak",
        "SMC_ICT_IsConfirmedSwingHigh",
        "SMC_ICT_IsConfirmedSwingLow",
    ):
        assert function_name in source, function_name


def test_library_does_not_claim_contextual_or_external_items_are_detected() -> None:
    assert HEADER.is_file(), "MQL5 include library has not been generated"
    source = HEADER.read_text(encoding="utf-8")

    contextual = _case_body(source, "C017")
    external = _case_body(source, "C102")
    community = _case_body(source, "C040")
    combination = _case_body(source, "C118")

    assert "SMC_ICT_SUPPORT_CONTEXT_ONLY" in contextual
    assert "SMC_ICT_SUPPORT_EXTERNAL_DATA" in external
    assert "SMC_ICT_SUPPORT_MANUAL_REVIEW" in community
    assert "SMC_ICT_SUPPORT_COMBINATION" in combination
