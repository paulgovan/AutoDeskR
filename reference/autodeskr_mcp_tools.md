# MCP tools for AutoDeskR

Returns a named list of
[`ellmer::tool()`](https://ellmer.tidyverse.org/reference/tool.html)
objects that expose AutoDeskR functions to AI models via the Model
Context Protocol (MCP). Credentials are read from the `APS_CLIENT_ID`
and `APS_CLIENT_SECRET` environment variables; no token argument is
required in any tool call.

## Usage

``` r
autodeskr_mcp_tools()
```

## Value

A named list of
[`ellmer::tool`](https://ellmer.tidyverse.org/reference/tool.html)
objects covering Authentication, Data Management, Model Derivative,
Design Automation, and Reality Capture.

## Examples

``` r
if (FALSE) { # \dontrun{
Sys.setenv(APS_CLIENT_ID = "your_id", APS_CLIENT_SECRET = "your_secret")
tools <- autodeskr_mcp_tools()
mcptools::mcp_server(tools = tools)
} # }
```
