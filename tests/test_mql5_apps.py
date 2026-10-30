from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[1]
INDICATOR = ROOT / "mql5" / "Indicators" / "SMC_ICT_Visualizer.mq5"
AUDIT_SCRIPT = ROOT / "mql5" / "Scripts" / "SMC_ICT_Audit1000.mq5"


def test_user_indicator_includes_library_and_draws_only_closed_bar_primitives() -> None:
    assert INDICATOR.is_file(), "user-facing MQL5 indicator has not been created"
    source = INDICATOR.read_text(encoding="utf-8-sig")
    assert "#property indicator_chart_window" in source
    assert "SMC_ICT_Library.mqh" in source
    assert "OnCalculate(" in source
    assert "CopyRates" in source
    assert "SMC_ICT_IsBullishFVG" in source
    assert "SMC_ICT_IsConfirmedSwingHigh" in source
    assert "SMC_ICT_IsLiquiditySweep" in source
    assert "OrderSend(" not in source
    assert "CTrade" not in source


def test_1000_bar_audit_visits_every_registered_candidate_without_trading() -> None:
    assert AUDIT_SCRIPT.is_file(), "1000-bar MQL5 audit script has not been created"
    source = AUDIT_SCRIPT.read_text(encoding="utf-8-sig")
    assert "SMC_ICT_Library.mqh" in source
    assert re.search(r"input int\s+InpBars\s*=\s*1000", source)
    assert "CopyRates" in source
    assert "start_pos" in source or "CopyRates(_Symbol" in source
    assert "SMC_ICT_GetDefinition" in source
    assert "SMC_ICT_CATALOG_COUNT" in source
    assert "event_count[i] = -1" in source
    assert "event_count[slot] < 0 ? \"NA\"" in source
    assert 'return "PRIMITIVE_ONLY_OR_PROXY"' in source
    assert 'return "PROXY_TESTED"' not in source
    assert "OrderSend(" not in source
    assert "CTrade" not in source
