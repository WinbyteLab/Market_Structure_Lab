from __future__ import annotations

import importlib.util
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "scripts" / "candidate_coverage_1000.py"


def _load_module():
    assert SCRIPT.is_file(), "1000-bar candidate coverage script has not been created"
    spec = importlib.util.spec_from_file_location("candidate_coverage_1000", SCRIPT)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_coverage_rows_include_every_candidate_and_preserve_unavailable_as_null() -> None:
    module = _load_module()
    records = [
        {"id": "C042", "term_en": "FVG", "term_ru": "Разрыв", "family": "pd_array", "type": "imbalance", "origin": "ICT", "source_refs": [42], "status": "candidate", "code_status": "primitive"},
        {"id": "C017", "term_en": "Order Flow", "term_ru": "Поток", "family": "order-flow", "type": "interpretive-framework", "origin": "ICT", "source_refs": [40], "status": "context", "code_status": "context-only"},
        {"id": "C118", "term_en": "Composite", "term_ru": "Комбинация", "family": "combination", "type": "entry-sequence", "origin": "ICT", "source_refs": [9], "status": "candidate", "code_status": "not-coded"},
    ]

    rows = module.build_coverage_rows(records, {"FVG_BULLISH": 7, "FVG_BEARISH": 5})
    by_id = {row["candidate_id"]: row for row in rows}

    assert list(by_id) == ["C042", "C017", "C118"]
    assert by_id["C042"]["reference_event_count"] == 12
    assert by_id["C042"]["coverage_status"] == "REFERENCE_EVENTS_AVAILABLE_NOT_MQL5_RUNTIME"
    assert by_id["C017"]["reference_event_count"] is None
    assert by_id["C017"]["coverage_status"] == "CONTEXT_ONLY"
    assert by_id["C118"]["reference_event_count"] is None
    assert by_id["C118"]["coverage_status"] == "COMBINATION_NOT_IMPLEMENTED"


def test_coverage_reports_do_not_call_unimplemented_items_zero_events() -> None:
    module = _load_module()
    row = module.build_coverage_rows(
        [{"id": "C118", "term_en": "Composite", "term_ru": "Комбинация", "family": "combination", "type": "entry-sequence", "origin": "ICT", "source_refs": [], "status": "candidate", "code_status": "not-coded"}],
        {},
    )[0]

    assert row["reference_event_count"] is None
    assert "NOT_IMPLEMENTED" in row["coverage_status"]
