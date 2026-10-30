from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
INDICATOR = ROOT / "mql5" / "Indicators" / "SMC_ICT_Visualizer.mq5"
BATCH_SCRIPT = ROOT / "mql5" / "Scripts" / "SMC_ICT_Test_1000Bars.mq5"


def test_user_indicator_includes_library_and_uses_closed_bar_calculation() -> None:
    assert INDICATOR.is_file(), "user-facing chart indicator has not been created"
    source = INDICATOR.read_text(encoding="utf-8-sig")
    assert "#property indicator_chart_window" in source
    assert "SMC_ICT_Library.mqh" in source
    assert "OnCalculate" in source
    assert "CopyRates" in source
    assert "SMC_ICT_IsBullishFVG" in source
    assert "SMC_ICT_IsLiquiditySweep" in source


def test_1000bar_mql5_script_covers_all_candidates_without_trading() -> None:
    assert BATCH_SCRIPT.is_file(), "1000-bar MQL5 script has not been created"
    source = BATCH_SCRIPT.read_text(encoding="utf-8-sig")
    assert "input int InpBars = 1000" in source
    assert "CopyRates(_Symbol, _Period, 1, InpBars" in source
    assert "SMC_ICT_CandidateCount()" in source
    assert "SMC_ICT_GetDefinition" in source
    assert "for(int value = 1; value <= SMC_ICT_CATALOG_COUNT; value++)" in source
    for forbidden in ("OrderSend(", "CTrade", ".Buy(", ".Sell(", "PositionOpen("):
        assert forbidden not in source
