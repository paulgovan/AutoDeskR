# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Package Overview

AutoDeskR is an R client library for the **AutoDesk Platform Services
(APS)** API (formerly AutoDesk Forge). It is published on CRAN and is
currently marked as **deprecated**. It exposes five AutoDesk APIs to R
users: Authentication, Data Management, Design Automation, Model
Derivative, and a Shiny-based Viewer.

## Common Commands

``` r
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

The package is organized into five R files under `R/`, each mapping to
one AutoDesk API:

| File                 | API                            | Key Functions                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
|----------------------|--------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `authentication.R`   | OAuth                          | [`getToken()`](http://paulgovan.github.io/AutoDeskR/reference/getToken.md)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `dataManagement.R`   | Data Management (OSS v2)       | [`makeBucket()`](http://paulgovan.github.io/AutoDeskR/reference/makeBucket.md), [`checkBucket()`](http://paulgovan.github.io/AutoDeskR/reference/checkBucket.md), [`uploadFile()`](http://paulgovan.github.io/AutoDeskR/reference/uploadFile.md)                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `designAutomation.R` | Design Automation (AutoCAD.io) | [`makePdf()`](http://paulgovan.github.io/AutoDeskR/reference/makePdf.md), [`checkPdf()`](http://paulgovan.github.io/AutoDeskR/reference/checkPdf.md)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `modelDerivative.R`  | Model Derivative v2            | [`translateSvf()`](http://paulgovan.github.io/AutoDeskR/reference/translateSvf.md), [`translateObj()`](http://paulgovan.github.io/AutoDeskR/reference/translateObj.md), [`checkFile()`](http://paulgovan.github.io/AutoDeskR/reference/checkFile.md), [`getMetadata()`](http://paulgovan.github.io/AutoDeskR/reference/getMetadata.md), [`getData()`](http://paulgovan.github.io/AutoDeskR/reference/getData.md), [`getObjectTree()`](http://paulgovan.github.io/AutoDeskR/reference/getObjectTree.md), [`getOutputUrn()`](http://paulgovan.github.io/AutoDeskR/reference/getOutputUrn.md), [`downloadFile()`](http://paulgovan.github.io/AutoDeskR/reference/downloadFile.md) |
| `viewer.R`           | Viewer                         | [`viewer3D()`](http://paulgovan.github.io/AutoDeskR/reference/viewer3D.md), [`viewerUI()`](http://paulgovan.github.io/AutoDeskR/reference/viewerUI.md)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |

**Typical workflow**:
[`getToken()`](http://paulgovan.github.io/AutoDeskR/reference/getToken.md)
→
[`makeBucket()`](http://paulgovan.github.io/AutoDeskR/reference/makeBucket.md)
→
[`uploadFile()`](http://paulgovan.github.io/AutoDeskR/reference/uploadFile.md)
→
[`translateSvf()`](http://paulgovan.github.io/AutoDeskR/reference/translateSvf.md)
→
[`viewer3D()`](http://paulgovan.github.io/AutoDeskR/reference/viewer3D.md)
or
[`downloadFile()`](http://paulgovan.github.io/AutoDeskR/reference/downloadFile.md)

All HTTP calls use `httr`; JSON parsing uses `jsonlite`. The viewer
integrates with Shiny via
[`viewerUI()`](http://paulgovan.github.io/AutoDeskR/reference/viewerUI.md)
for embedding in apps, or
[`viewer3D()`](http://paulgovan.github.io/AutoDeskR/reference/viewer3D.md)
for a standalone app (supports header/headless/VR modes).

## Documentation

- All public functions are documented with roxygen2. Run
  `devtools::document()` after changing `@param`, `@return`, or
  `@export` tags.
- The pkgdown site is deployed automatically via GitHub Actions
  (`.github/workflows/pkgdown.yaml`) on push to master.
- Vignettes live in `vignettes/` and use knitr/rmarkdown.
- Function examples use `\dontrun{}` blocks since they require live
  AutoDesk credentials.

## Dependencies

Core: `httr` (HTTP requests), `jsonlite` (JSON), `shiny` (viewer UI).
All are listed in `DESCRIPTION` under `Imports`.
