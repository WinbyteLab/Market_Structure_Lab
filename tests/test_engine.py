import unittest

from ict_smc_mcp.engine import analyze_bars, normalize_bars


def bar(i, *, o, h, l, c):
    return {"time": f"2026-01-01T00:{i:02d}:00+00:00", "open": o, "high": h, "low": l, "close": c, "spread": 1}


class BarValidationTests(unittest.TestCase):
    def test_rejects_invalid_ohlc_range(self):
        with self.assertRaisesRegex(ValueError, "OHLC"):
            normalize_bars([bar(0, o=10, h=9, l=8, c=9)])

    def test_sorts_bars_by_utc_time_and_rejects_duplicates(self):
        values = [bar(2, o=2, h=3, l=1, c=2), bar(1, o=2, h=3, l=1, c=2)]
        normalized = normalize_bars(values)
        self.assertTrue(normalized[0]["time_utc"] < normalized[1]["time_utc"])
        with self.assertRaisesRegex(ValueError, "duplicate"):
            normalize_bars([bar(1, o=2, h=3, l=1, c=2), bar(1, o=2, h=3, l=1, c=2)])


class FairValueGapTests(unittest.TestCase):
    def test_bullish_fvg_is_confirmed_on_third_bar_close(self):
        bars = [
            bar(0, o=100, h=101, l=99, c=100),
            bar(1, o=100, h=104, l=100, c=103),
            bar(2, o=103, h=105, l=102, c=104),
        ]
        events = analyze_bars(bars, left=1, right=1)["events"]
        fvg = next(e for e in events if e["type"] == "FVG_BULLISH")
        self.assertEqual((fvg["lower"], fvg["upper"]), (101.0, 102.0))
        self.assertEqual(fvg["formation_start_index"], 0)
        self.assertEqual(fvg["confirmed_index"], 2)
        self.assertEqual(fvg["confirmation_time_utc"], "2026-01-01T00:02:00Z")

    def test_bearish_fvg_uses_mirrored_three_bar_rule(self):
        bars = [
            bar(0, o=100, h=103, l=99, c=101),
            bar(1, o=101, h=102, l=96, c=97),
            bar(2, o=97, h=98, l=95, c=96),
        ]
        events = analyze_bars(bars, left=1, right=1)["events"]
        fvg = next(e for e in events if e["type"] == "FVG_BEARISH")
        self.assertEqual((fvg["lower"], fvg["upper"]), (98.0, 99.0))
        self.assertEqual(fvg["confirmed_index"], 2)

    def test_equal_wicks_do_not_form_fvg_and_touch_requires_later_bar(self):
        equal = [
            bar(0, o=100, h=101, l=99, c=100),
            bar(1, o=100, h=102, l=100, c=101),
            bar(2, o=101, h=103, l=101, c=102),
        ]
        self.assertFalse(any(e["type"].startswith("FVG_") for e in analyze_bars(equal)["events"]))

        bars = [
            bar(0, o=100, h=101, l=99, c=100),
            bar(1, o=100, h=104, l=100, c=103),
            bar(2, o=103, h=105, l=102, c=104),
            bar(3, o=103, h=103.5, l=101.5, c=102),
        ]
        fvg = next(e for e in analyze_bars(bars)["events"] if e["type"] == "FVG_BULLISH")
        self.assertEqual(fvg["first_touch_index"], 3)

    def test_no_touch_is_reported_as_none(self):
        bars = [
            bar(0, o=100, h=101, l=99, c=100),
            bar(1, o=100, h=104, l=100, c=103),
            bar(2, o=103, h=105, l=102, c=104),
            bar(3, o=104, h=107, l=103, c=106),
        ]
        fvg = next(e for e in analyze_bars(bars)["events"] if e["type"] == "FVG_BULLISH")
        self.assertIsNone(fvg["first_touch_index"])


class StructureAndLiquidityTests(unittest.TestCase):
    def test_swing_pivot_is_unavailable_until_right_bars_close(self):
        bars = [
            bar(0, o=9, h=10, l=8, c=9),
            bar(1, o=10, h=12, l=9, c=11),
            bar(2, o=13, h=15, l=12, c=14),
            bar(3, o=11, h=12, l=10, c=11),
            bar(4, o=12, h=13, l=11, c=12),
        ]
        events = analyze_bars(bars, left=1, right=1)["events"]
        swing = next(e for e in events if e["type"] == "SWING_HIGH_CONFIRMED" and e["pivot_index"] == 2)
        self.assertEqual(swing["available_index"], 3)
        self.assertEqual(swing["confirmed_index"], 3)

    def test_bos_requires_close_through_previously_confirmed_swing(self):
        bars = [
            bar(0, o=9, h=10, l=8, c=9),
            bar(1, o=10, h=12, l=9, c=11),
            bar(2, o=13, h=15, l=12, c=14),
            bar(3, o=11, h=12, l=10, c=11),
            bar(4, o=14, h=16, l=13, c=15.5),
        ]
        events = analyze_bars(bars, left=1, right=1)["events"]
        broken = [e for e in events if e["type"] in {"BOS_UP", "MSS_UP"}]
        self.assertEqual(len(broken), 1)
        self.assertEqual(broken[0]["confirmed_index"], 4)
        self.assertEqual(broken[0]["level"], 15.0)

    def test_liquidity_sweep_requires_wick_through_and_close_back_inside(self):
        bars = [
            bar(0, o=9, h=10, l=8, c=9),
            bar(1, o=10, h=12, l=9, c=11),
            bar(2, o=13, h=15, l=12, c=14),
            bar(3, o=11, h=12, l=10, c=11),
            bar(4, o=14, h=16, l=13, c=14.5),
        ]
        events = analyze_bars(bars, left=1, right=1)["events"]
        sweep = next(e for e in events if e["type"] == "BUY_SIDE_SWEEP")
        self.assertEqual(sweep["confirmed_index"], 4)
        self.assertEqual(sweep["level"], 15.0)

    def test_order_block_is_explicitly_labeled_as_mechanical_proxy(self):
        bars = [
            bar(0, o=9, h=10, l=8, c=9),
            bar(1, o=10, h=12, l=9, c=11),
            bar(2, o=13, h=15, l=12, c=14),
            bar(3, o=12, h=13, l=10, c=11),
            bar(4, o=14, h=16, l=13, c=15.5),
        ]
        events = analyze_bars(bars, left=1, right=1)["events"]
        block = next(e for e in events if e["type"] == "OB_BULL_PROXY")
        self.assertEqual(block["source_candle_index"], 3)
        self.assertEqual(block["confirmed_index"], 4)
        self.assertIn("proxy", block["definition_status"])


if __name__ == "__main__":
    unittest.main()
