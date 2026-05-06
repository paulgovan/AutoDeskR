# Launch AutoDeskR as an MCP server.
#
# Set APS_CLIENT_ID and APS_CLIENT_SECRET in your environment before running:
#
#   Sys.setenv(APS_CLIENT_ID = "your_client_id",
#              APS_CLIENT_SECRET = "your_client_secret")
#
# To register with Claude Code (run once in a terminal):
#
#   claude mcp add -s user autodeskr -- Rscript \
#     /path/to/AutoDeskR/inst/mcp-server.R
#
# To register with Claude Desktop, add to claude_desktop_config.json:
#
#   "autodeskr": {
#     "command": "Rscript",
#     "args": ["/path/to/AutoDeskR/inst/mcp-server.R"],
#     "env": {
#       "APS_CLIENT_ID": "your_client_id",
#       "APS_CLIENT_SECRET": "your_client_secret"
#     }
#   }

library(AutoDeskR)
library(mcptools)

mcptools::mcp_server(tools = AutoDeskR::autodeskr_mcp_tools())
