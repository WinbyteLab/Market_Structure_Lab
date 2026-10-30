import unittest
from datetime import datetime, timezone

from ict_smc_mcp.mt5_bridge import ReadOnlyMT5, normalize_count


class FakeMT5:
    TIMEFRAME_M1 = 1
    TIMEFRAME_H1 = 13
    TIMEFRAME_D1 = 16408

    def __init__(self):
        self.shutdown_calls = 0
        self.rate_calls = []
        self.order_send_calls = 0
        self.return_none_rates = False

    def initialize(self):
        return True

    def shutdown(self):
        self.shutdown_calls += 1

    def last_error(self):
        return (0, "Success")

    def terminal_info(self):
        return {"connected": True, "login": 987654}

    def version(self):
        return (500, 6230, "test")

    def symbols_get(self):
        return [
            {"name": "EURUSDrfd", "description": "Euro/US Dollar", "visible": True},
            {"name": "GBPUSDrfd", "description": "Pound/US Dollar", "visible": False},
        ]

    def symbol_info(self, symbol):
        if symbol != "EURUSDrfd":
            return None
        return {
            "name": symbol,
            "description": "Euro/US Dollar",
            "digits": 5,
            "point": 0.00001,
            "currency_base": "EUR",
            "currency_profit": "USD",
            "visible": True,
            "login": 987654,
        }

    def copy_rates_from_pos(self, symbol, timeframe, start_pos, count):
        self.rate_calls.append((symbol, timeframe, start_pos, count))
        if self.return_none_rates:
            return None
        return [
            {"time": 1761782400, "open": 1.1, "high": 1.2, "low": 1.0, "close": 1.15,
             "tick_volume": 10, "spread": 12, "real_volume": 0},
            {"time": 1761786000, "open": 1.15, "high": 1.25, "low": 1.1, "close": 1.2,
             "tick_volume": 11, "spread": 13, "real_volume": 0},
        ][:count]

    def order_send(self, request):
        self.order_send_calls += 1
        raise AssertionError("read-only MCP must never send orders")


class ReadOnlyMT5Tests(unittest.TestCase):
    def test_rates_support_numpy_structured_record_rows(self):
        class StructuredRow:
            def __init__(self, values):
                self.values = values

            def __getitem__(self, key):
                return self.values[key]

        class StructuredFakeMT5(FakeMT5):
            def copy_rates_from_pos(self, symbol, timeframe, start_pos, count):
                return [StructuredRow({
                    "time": 1761782400, "open": 1.1, "high": 1.2, "low": 1.0,
                    "close": 1.15, "tick_volume": 10, "spread": 12, "real_volume": 0,
                })]

        result = ReadOnlyMT5(StructuredFakeMT5()).rates("EURUSDrfd", "H1", 1)
        self.assertEqual(result["bars"][0]["close"], 1.15)
        self.assertEqual(result["returned_count"], 1)

    def test_status_returns_connection_only_not_account_identity(self):
        api = FakeMT5()
        result = ReadOnlyMT5(api).status()
        self.assertEqual(result["connected"], True)
        self.assertNotIn("login", result)
        self.assertEqual(api.shutdown_calls, 1)

    def test_symbol_search_is_bounded_and_case_insensitive(self):
        api = FakeMT5()
        result = ReadOnlyMT5(api).list_symbols(query="eur", limit=5)
        self.assertEqual(result["count"], 1)
        self.assertEqual(result["symbols"][0]["name"], "EURUSDrfd")

    def test_symbol_info_omits_unapproved_fields(self):
        api = FakeMT5()
        result = ReadOnlyMT5(api).symbol_info("EURUSDrfd")
        self.assertEqual(result["digits"], 5)
        self.assertNotIn("login", result)

    def test_rates_default_to_closed_bars_and_normalize_utc(self):
        api = FakeMT5()
        result = ReadOnlyMT5(api).rates("EURUSDrfd", "H1", 2)
        self.assertEqual(api.rate_calls, [("EURUSDrfd", api.TIMEFRAME_H1, 1, 2)])
        self.assertEqual(result["closed_only"], True)
        self.assertEqual(len(result["bars"]), 2)
        self.assertEqual(result["bars"][0]["time"], datetime.fromtimestamp(1761782400, timezone.utc).isoformat().replace("+00:00", "Z"))
        self.assertEqual(api.order_send_calls, 0)
        self.assertEqual(api.shutdown_calls, 1)

    def test_rates_reject_invalid_timeframe_and_empty_symbol(self):
        api = FakeMT5()
        with self.assertRaisesRegex(ValueError, "symbol"):
            ReadOnlyMT5(api).rates(" ", "H1", 3)
        with self.assertRaisesRegex(ValueError, "timeframe"):
            ReadOnlyMT5(api).rates("EURUSDrfd", "H2", 3)

    def test_rates_api_failure_is_not_returned_as_empty_success(self):
        api = FakeMT5()
        api.return_none_rates = True
        with self.assertRaisesRegex(RuntimeError, "copy_rates_from_pos"):
            ReadOnlyMT5(api).rates("EURUSDrfd", "H1", 3)

    def test_count_is_integer_bounded_and_rejects_bool(self):
        self.assertEqual(normalize_count(10001), 5000)
        with self.assertRaises(ValueError):
            normalize_count(True)
        with self.assertRaises(ValueError):
            normalize_count(0)
        with self.assertRaises(ValueError):
            normalize_count(1.5)


if __name__ == "__main__":
    unittest.main()
