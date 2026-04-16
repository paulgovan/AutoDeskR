# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

AutoDeskR is an R client library for the **AutoDesk Platform Services (APS)** API (formerly AutoDesk Forge). It is published on CRAN and is currently marked as **deprecated**. It exposes five AutoDesk APIs to R users: Authentication, Data Management, Design Automation, Model Derivative, and a Shiny-based Viewer.

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

There is no test suite — the `tests/` directory does not exist.

## Architecture

The package is organized into five R files under `R/`, each mapping to one AutoDesk API:

| File | API | Key Functions |
|------|-----|---------------|
| `authentication.R` | OAuth | `getToken()` |
| `dataManagement.R` | Data Management (OSS v2) | `makeBucket()`, `checkBucket()`, `uploadFile()` |
| `designAutomation.R` | Design Automation (AutoCAD.io) | `makePdf()`, `checkPdf()` |
| `modelDerivative.R` | Model Derivative v2 | `translateSvf()`, `translateObj()`, `checkFile()`, `getMetadata()`, `getData()`, `getObjectTree()`, `getOutputUrn()`, `downloadFile()` |
| `viewer.R` | Viewer | `viewer3D()`, `viewerUI()` |

**Typical workflow**: `getToken()` → `makeBucket()` → `uploadFile()` → `translateSvf()` → `viewer3D()` or `downloadFile()`

All HTTP calls use `httr`; JSON parsing uses `jsonlite`. The viewer integrates with Shiny via `viewerUI()` for embedding in apps, or `viewer3D()` for a standalone app (supports header/headless/VR modes).

## Documentation

- All public functions are documented with roxygen2. Run `devtools::document()` after changing `@param`, `@return`, or `@export` tags.
- The pkgdown site is deployed automatically via GitHub Actions (`.github/workflows/pkgdown.yaml`) on push to master.
- Vignettes live in `vignettes/` and use knitr/rmarkdown.
- Function examples use `\dontrun{}` blocks since they require live AutoDesk credentials.

## Dependencies

Core: `httr` (HTTP requests), `jsonlite` (JSON), `shiny` (viewer UI). All are listed in `DESCRIPTION` under `Imports`.
