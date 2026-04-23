# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Package Overview

AutoDeskR is an R client library for the **AutoDesk Platform Services
(APS)** API (formerly AutoDesk Forge). It is published on CRAN. It
exposes five AutoDesk APIs to R users: Authentication, Data Management,
Design Automation, Model Derivative, and a Shiny-based Viewer.

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

A `testthat` + `httptest2` test suite lives in `tests/testthat/`. Mocked
API fixtures are stored under
`tests/testthat/developer.api.autodesk.com/`. Run with
`devtools::test()`. No live AutoDesk credentials are required.

## Architecture

The package is organized into five R files under `R/`, each mapping to
one AutoDesk API:

| File                 | API                      | Key Functions                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
|----------------------|--------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `authentication.R`   | OAuth                    | [`getToken()`](http://paulgovan.github.io/AutoDeskR/reference/getToken.md)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `dataManagement.R`   | Data Management (OSS v2) | [`makeBucket()`](http://paulgovan.github.io/AutoDeskR/reference/makeBucket.md), [`checkBucket()`](http://paulgovan.github.io/AutoDeskR/reference/checkBucket.md), [`uploadFile()`](http://paulgovan.github.io/AutoDeskR/reference/uploadFile.md), [`listBuckets()`](http://paulgovan.github.io/AutoDeskR/reference/listBuckets.md), [`listObjects()`](http://paulgovan.github.io/AutoDeskR/reference/listObjects.md), etc.                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `designAutomation.R` | Design Automation v3     | [`makePdf()`](http://paulgovan.github.io/AutoDeskR/reference/makePdf.md), [`checkPdf()`](http://paulgovan.github.io/AutoDeskR/reference/checkPdf.md)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `modelDerivative.R`  | Model Derivative v2      | [`translateSvf()`](http://paulgovan.github.io/AutoDeskR/reference/translateSvf.md), [`translateSvf2()`](http://paulgovan.github.io/AutoDeskR/reference/translateSvf2.md), [`translateObj()`](http://paulgovan.github.io/AutoDeskR/reference/translateObj.md), [`translateStl()`](http://paulgovan.github.io/AutoDeskR/reference/translateStl.md), [`checkFile()`](http://paulgovan.github.io/AutoDeskR/reference/checkFile.md), [`getMetadata()`](http://paulgovan.github.io/AutoDeskR/reference/getMetadata.md), [`getData()`](http://paulgovan.github.io/AutoDeskR/reference/getData.md), [`getObjectTree()`](http://paulgovan.github.io/AutoDeskR/reference/getObjectTree.md), [`getOutputUrn()`](http://paulgovan.github.io/AutoDeskR/reference/getOutputUrn.md), [`downloadFile()`](http://paulgovan.github.io/AutoDeskR/reference/downloadFile.md) |
| `realityCapture.R`   | Reality Capture          | [`createPhotoscene()`](http://paulgovan.github.io/AutoDeskR/reference/createPhotoscene.md), [`uploadImages()`](http://paulgovan.github.io/AutoDeskR/reference/uploadImages.md), [`processPhotoscene()`](http://paulgovan.github.io/AutoDeskR/reference/processPhotoscene.md), [`checkPhotoscene()`](http://paulgovan.github.io/AutoDeskR/reference/checkPhotoscene.md)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `viewer.R`           | Viewer                   | [`viewer3D()`](http://paulgovan.github.io/AutoDeskR/reference/viewer3D.md), [`viewerUI()`](http://paulgovan.github.io/AutoDeskR/reference/viewerUI.md)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `utils.R`            | Utilities                | [`aps_error()`](http://paulgovan.github.io/AutoDeskR/reference/aps_error.md), [`is_expired()`](http://paulgovan.github.io/AutoDeskR/reference/is_expired.md), [`waitForFile()`](http://paulgovan.github.io/AutoDeskR/reference/waitForFile.md), [`waitForWorkItem()`](http://paulgovan.github.io/AutoDeskR/reference/waitForWorkItem.md), [`as_tibble.listBuckets()`](http://paulgovan.github.io/AutoDeskR/reference/as_tibble.listBuckets.md), [`as_tibble.listObjects()`](http://paulgovan.github.io/AutoDeskR/reference/as_tibble.listObjects.md)                                                                                                                                                                                                                                                                                                     |
| `print.R`            | Print methods            | S3 `print.*` methods for all response classes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |

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

All HTTP calls use `httr2`; JSON parsing uses `jsonlite`. The viewer
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

Core: `httr2` (HTTP requests), `jsonlite` (JSON), `shiny` (viewer UI).
All are listed in `DESCRIPTION` under `Imports`. `tibble` is in
`Suggests` for optional tidy output via `as_tibble()` methods.
