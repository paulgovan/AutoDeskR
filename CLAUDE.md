# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

AutoDeskR is an R client library for the **AutoDesk Platform Services (APS)** API (formerly AutoDesk Forge). It is published on CRAN. It exposes five AutoDesk APIs to R users: Authentication, Data Management, Design Automation, Model Derivative, and a Shiny-based Viewer.

## Common Commands

```r
# Load package for development
devtools::load_all()

# Regenerate documentation from roxygen2 comments
devtools::document()

# Run R CMD check
devtools::check()

# Build pkgdown documentation site
pkgdown::build_site()
```

A `testthat` + `httptest2` test suite lives in `tests/testthat/`. Mocked API fixtures are stored under `tests/testthat/developer.api.autodesk.com/`. Run with `devtools::test()`. No live AutoDesk credentials are required.

## Architecture

The package is organized into five R files under `R/`, each mapping to one AutoDesk API:

| File | API | Key Functions |
|------|-----|---------------|
| `authentication.R` | OAuth | `getToken()` |
| `dataManagement.R` | Data Management (OSS v2) | `makeBucket()`, `checkBucket()`, `uploadFile()`, `listBuckets()`, `listObjects()`, etc. |
| `designAutomation.R` | Design Automation v3 | `makePdf()`, `checkPdf()` |
| `modelDerivative.R` | Model Derivative v2 | `translateSvf()`, `translateSvf2()`, `translateObj()`, `translateStl()`, `checkFile()`, `getMetadata()`, `getData()`, `getObjectTree()`, `getOutputUrn()`, `downloadFile()` |
| `realityCapture.R` | Reality Capture | `createPhotoscene()`, `uploadImages()`, `processPhotoscene()`, `checkPhotoscene()` |
| `viewer.R` | Viewer | `viewer3D()`, `viewerUI()` |
| `utils.R` | Utilities | `aps_error()`, `is_expired()`, `waitForFile()`, `waitForWorkItem()`, `as_tibble.listBuckets()`, `as_tibble.listObjects()` |
| `print.R` | Print methods | S3 `print.*` methods for all response classes |

**Typical workflow**: `getToken()` → `makeBucket()` → `uploadFile()` → `translateSvf()` → `viewer3D()` or `downloadFile()`

All HTTP calls use `httr2`; JSON parsing uses `jsonlite`. The viewer integrates with Shiny via `viewerUI()` for embedding in apps, or `viewer3D()` for a standalone app (supports header/headless/VR modes).

## Documentation

- All public functions are documented with roxygen2. Run `devtools::document()` after changing `@param`, `@return`, or `@export` tags.
- The pkgdown site is deployed automatically via GitHub Actions (`.github/workflows/pkgdown.yaml`) on push to master.
- Vignettes live in `vignettes/` and use knitr/rmarkdown.
- Function examples use `\dontrun{}` blocks since they require live AutoDesk credentials.

## Dependencies

Core: `httr2` (HTTP requests), `jsonlite` (JSON), `shiny` (viewer UI). All are listed in `DESCRIPTION` under `Imports`. `tibble` is in `Suggests` for optional tidy output via `as_tibble()` methods.
