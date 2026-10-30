import unittest

from ict_smc_mcp.service import ResearchService


def sample_bars():
    return [
        {"time": "2026-01-01T00:00:00Z", "open": 100, "high": 101, "low": 99, "close": 100},
        {"time": "2026-01-01T00:01:00Z", "open": 100, "high": 104, "low": 100, "close": 103},
        {"time": "2026-01-01T00:02:00Z", "open": 103, "high": 105, "low": 102, "close": 104},
    ]


class FakeBridge:
    def __init__(self, payload=None):
        self.payload = payload or {
            "symbol": "EURUSD",
            "timeframe": "M1",
            "requested_count": 3,
            "returned_count": 3,
            "closed_only": True,
            "start_pos": 1,
            "bars": sample_bars(),
        }
        self.calls = []

    def rates(self, symbol, timeframe, count):
        self.calls.append((symbol, timeframe, count))
        return self.payload


class ResearchServiceTests(unittest.TestCase):
    def test_analysis_preserves_market_provenance_and_returns_event_counts(self):
        bridge = FakeBridge()
        result = ResearchService(bridge).analyze_market(
            "EURUSD", "M1", 3, left=1, right=1, min_fvg_gap=0.0, ob_lookback=5
        )
        self.assertEqual(bridge.calls, [("EURUSD", "M1", 3)])
        self.assertEqual(result["market"]["symbol"], "EURUSD")
        self.assertEqual(result["market"]["timeframe"], "M1")
        self.assertTrue(result["market"]["closed_bars_only"])
        self.assertEqual(result["bar_count"], 3)
        self.assertEqual(result["event_counts"]["FVG_BULLISH"], 1)

    def test_analysis_refuses_payload_that_includes_forming_bar(self):
        payload = FakeBridge().payload | {"closed_only": False}
        with self.assertRaisesRegex(ValueError, "closed bars"):
            ResearchService(FakeBridge(payload)).analyze_market(
                "EURUSD", "M1", 3, left=1, right=1, min_fvg_gap=0.0, ob_lookback=5
            )

    def test_analysis_rejects_requested_symbol_mismatch(self):
        payload = FakeBridge().payload | {"symbol": "GBPUSD"}
        with self.assertRaisesRegex(ValueError, "does not match"):
            ResearchService(FakeBridge(payload)).analyze_market(
                "EURUSD", "M1", 3, left=1, right=1, min_fvg_gap=0.0, ob_lookback=5
            )


if __name__ == "__main__":
    unittest.main()
