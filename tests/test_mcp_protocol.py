import asyncio
import os
import sys
import unittest
from pathlib import Path

from mcp import ClientSession
from mcp.client.stdio import StdioServerParameters, stdio_client


class MCPProtocolTests(unittest.TestCase):
    def test_server_handshake_and_tool_inventory_are_read_only(self):
        async def exercise():
            project_root = Path(__file__).resolve().parents[1]
            child_env = os.environ.copy()
            source_root = str(project_root / "src")
            child_env["PYTHONPATH"] = source_root + (
                os.pathsep + child_env["PYTHONPATH"] if child_env.get("PYTHONPATH") else ""
            )
            params = StdioServerParameters(
                command=sys.executable,
                args=["-c", "from ict_smc_mcp.server import create_server; create_server(bridge=object()).run(transport='stdio')"],
                env=child_env,
                cwd=project_root,
            )
            async with stdio_client(params) as (read_stream, write_stream):
                async with ClientSession(read_stream, write_stream) as session:
                    await session.initialize()
                    result = await session.list_tools()
                    names = {tool.name for tool in result.tools}
                    self.assertTrue({
                        "mt5_status",
                        "list_symbols",
                        "get_rates",
                        "analyze_market",
                    }.issubset(names))
                    self.assertFalse(any("order" in name.casefold() for name in names))
        asyncio.run(exercise())


if __name__ == "__main__":
    unittest.main()
