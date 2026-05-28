---
output: github_document
---

# AutoDeskR <a href="http://paulgovan.github.io/AutoDeskR/"><img src="man/figures/logo.png" align="right" height="139" alt="AutoDeskR website" /></a>

<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN status](https://www.r-pkg.org/badges/version/AutoDeskR)](https://CRAN.R-project.org/package=AutoDeskR)
[![R-CMD-check](https://github.com/paulgovan/AutoDeskR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/paulgovan/AutoDeskR/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/paulgovan/AutoDeskR/graph/badge.svg)](https://app.codecov.io/gh/paulgovan/AutoDeskR)
[![](http://cranlogs.r-pkg.org/badges/last-month/AutoDeskR)](https://cran.r-project.org/package=AutoDeskR)
[![](http://cranlogs.r-pkg.org/badges/grand-total/AutoDeskR)](https://cran.r-project.org/package=AutoDeskR)
[![](https://img.shields.io/badge/doi-10.32614/CRAN.package.AutoDeskR-green.svg)](https://doi.org/10.32614/CRAN.package.AutoDeskR)
<!-- badges: end -->

## Introduction

AutoDeskR is an R package that provides an interface to the:

* **[Authentication API](https://paulgovan.github.io/AutoDeskR-Book/authentication.html)** — obtain OAuth2 tokens with expiry tracking via the `aps_token` class.
* **[Data Management API](https://paulgovan.github.io/AutoDeskR-Book/data-management.html)** — manage buckets and objects across the platform's cloud services.
* **[Design Automation API](https://paulgovan.github.io/AutoDeskR-Book/design-automation.html)** — run automated tasks on design files in the cloud.
* **[Model Derivative API](https://paulgovan.github.io/AutoDeskR-Book/model-derivative.html)** — translate design files into SVF, SVF2, OBJ, and STL formats and extract model data.
* **[Reality Capture API](https://paulgovan.github.io/AutoDeskR-Book/reality-capture.html)** — generate 3D models from photogrammetry image sets.
* **[Viewer](https://paulgovan.github.io/AutoDeskR-Book/viewer.html)** — render 2D and 3D models in Shiny applications.
* **[MCP Tools](https://paulgovan.github.io/AutoDeskR-Book/mcp-server.html)** — expose AutoDeskR functions to AI models via the Model Context Protocol using `ellmer` and `mcptools`.

Learn more in the [Companion Book](https://paulgovan.github.io/AutoDeskR-Book/getting-started.html).

![](https://github.com/paulgovan/AutoDeskR/blob/master/inst/images/basicSample.png?raw=true)

## Quick Start

To install AutoDeskR in [R](https://www.r-project.org):

```r
install.packages("AutoDeskR")
```

Or to install the development version:

```r
devtools::install_github("paulgovan/AutoDeskR")
```

### Basic workflow

```r
library(AutoDeskR)

# 1. Authenticate
tok <- getToken(id = Sys.getenv("APS_CLIENT_ID"), secret = Sys.getenv("APS_CLIENT_SECRET"))
is_expired(tok)  # FALSE

# 2. Upload a file
makeBucket(token = tok, bucket = "mybucket")
uploadFile(file = "aerial.dwg", token = tok, bucket = "mybucket")

# 3. Translate and wait
resp <- translateSvf2(urn = myEncodedUrn, token = tok)
done <- waitForFile(urn = myEncodedUrn, token = tok)

# 4. Tidy output (requires tibble)
library(tibble)
listBuckets(token = tok) |> as_tibble()
```

## MCP Tools

AutoDeskR exposes its functions to AI models via the [Model Context Protocol](https://modelcontextprotocol.io) (MCP). Use `autodeskr_mcp_tools()` to start an MCP server that AI assistants can call directly — no token argument required; credentials are read from the `APS_CLIENT_ID` and `APS_CLIENT_SECRET` environment variables.

```r
# Requires the ellmer and mcptools packages
install.packages(c("ellmer", "mcptools"))

Sys.setenv(APS_CLIENT_ID = "your_id", APS_CLIENT_SECRET = "your_secret")
tools <- autodeskr_mcp_tools()
mcptools::mcp_server(tools = tools)
```

The server exposes tools for all five APIs: Authentication, Data Management, Model Derivative, Design Automation, and Reality Capture.

## Code of Conduct

Please note that the AutoDeskR project is released with a [Contributor Code of Conduct](http://paulgovan.github.io/AutoDeskR/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

## Acknowledgements

Many thanks to the developers at AutoDesk for providing this great set of tools and for the support needed to learn and implement these APIs.
