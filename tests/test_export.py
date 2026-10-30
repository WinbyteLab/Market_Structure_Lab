import unittest
from pathlib import Path
from tempfile import TemporaryDirectory

from ict_smc_mcp.server import _write_csv


TEST_TEMP_PARENT = Path(__file__).resolve().parent


class CsvExportTests(unittest.TestCase):
    def test_repeated_exports_do_not_overwrite_an_earlier_snapshot(self):
        payload = {
            "symbol": "EURUSD",
            "timeframe": "M1",
            "closed_only": True,
            "bars": [{"time": "2026-01-01T00:00:00Z", "open": 1.0, "high": 1.1,
                      "low": 0.9, "close": 1.05, "tick_volume": 10, "spread": 1,
                      "real_volume": 0}],
        }
        with TemporaryDirectory(dir=TEST_TEMP_PARENT) as temp_root:
            root = Path(temp_root)
            first = _write_csv(root, payload)
            second = _write_csv(root, payload)
            self.assertNotEqual(first["relative_path"], second["relative_path"])
            self.assertTrue((root / first["relative_path"]).is_file())
            self.assertTrue((root / second["relative_path"]).is_file())

    def test_untrusted_symbol_cannot_escape_project_directory(self):
        payload = {
            "symbol": "../../outside",
            "timeframe": "M1",
            "closed_only": True,
            "bars": [],
        }
        with TemporaryDirectory(dir=TEST_TEMP_PARENT) as temp_root:
            root = Path(temp_root)
            result = _write_csv(root, payload)
            output = (root / result["relative_path"]).resolve()
            self.assertIn("raw", output.parts)
            self.assertTrue(output.is_file())


if __name__ == "__main__":
    unittest.main()
