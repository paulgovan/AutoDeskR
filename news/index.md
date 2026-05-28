# Changelog

## AutoDeskR 0.5.0

CRAN release: 2026-05-28

### New Functions

- [`autodeskr_mcp_tools()`](https://paulgovan.github.io/AutoDeskR/reference/autodeskr_mcp_tools.md)
  — expose all AutoDeskR API functions to AI models via the Model
  Context Protocol (MCP); credentials are read from environment
  variables so no token argument is required. Requires `ellmer` and
  `mcptools`.
- [`waitForPhotoscene()`](https://paulgovan.github.io/AutoDeskR/reference/waitForPhotoscene.md)
  — poll
  [`checkPhotoscene()`](https://paulgovan.github.io/AutoDeskR/reference/checkPhotoscene.md)
  until a Reality Capture photoscene processing job completes.

### Infrastructure

- pkgdown site added and deployed to GitHub Pages at
  <https://paulgovan.github.io/AutoDeskR/> via a new GitHub Actions
  workflow.
- `inst/CITATION` updated to reference the current companion book at
  <https://paulgovan.github.io/AutoDeskR-Book/>.
- `ellmer` and `mcptools` added to `Suggests`.

## AutoDeskR 0.4.0

### New Functions

- [`translateSvf2()`](https://paulgovan.github.io/AutoDeskR/reference/translateSvf2.md)
  — translate design files to SVF2 format (~30% smaller than SVF, faster
  rendering in the Viewer).
- [`createPhotoscene()`](https://paulgovan.github.io/AutoDeskR/reference/createPhotoscene.md),
  [`uploadImages()`](https://paulgovan.github.io/AutoDeskR/reference/uploadImages.md),
  [`processPhotoscene()`](https://paulgovan.github.io/AutoDeskR/reference/processPhotoscene.md),
  [`checkPhotoscene()`](https://paulgovan.github.io/AutoDeskR/reference/checkPhotoscene.md)
  — Reality Capture API for photogrammetry and 3D model generation from
  images.
- [`waitForFile()`](https://paulgovan.github.io/AutoDeskR/reference/waitForFile.md)
  — poll
  [`checkFile()`](https://paulgovan.github.io/AutoDeskR/reference/checkFile.md)
  until a Model Derivative translation completes.
- [`waitForWorkItem()`](https://paulgovan.github.io/AutoDeskR/reference/waitForWorkItem.md)
  — poll
  [`checkPdf()`](https://paulgovan.github.io/AutoDeskR/reference/checkPdf.md)
  until a Design Automation WorkItem completes.
- [`is_expired()`](https://paulgovan.github.io/AutoDeskR/reference/is_expired.md)
  — check whether an `aps_token` has expired.
- [`aps_error()`](https://paulgovan.github.io/AutoDeskR/reference/aps_error.md)
  — structured S3 error condition for APS API failures; catch with
  `tryCatch(..., aps_error = function(e) ...)`.

### Improvements

- [`getToken()`](https://paulgovan.github.io/AutoDeskR/reference/getToken.md)
  now returns an `aps_token` object with expiry tracking (`$expires_at`,
  [`is_expired()`](https://paulgovan.github.io/AutoDeskR/reference/is_expired.md)).
  Existing code using `resp$content$access_token` continues to work
  unchanged.
- All API functions now accept an `aps_token` object in place of a raw
  token string. Expired tokens trigger a warning.
- API errors now include decoded JSON messages from APS rather than raw
  HTTP error text.
- [`as_tibble()`](https://tibble.tidyverse.org/reference/as_tibble.html)
  methods added for `listBuckets` and `listObjects` response objects
  (requires the `tibble` package).

### Infrastructure

- Minimum R version bumped from 2.10.0 to 4.1.0.
- `tibble` added to `Suggests`.

## AutoDeskR 0.3.0

### Bug Fixes

- Fixed `<-` arrow-assignment bugs in
  [`getData()`](https://paulgovan.github.io/AutoDeskR/reference/getData.md),
  [`getObjectTree()`](https://paulgovan.github.io/AutoDeskR/reference/getObjectTree.md),
  [`translateObj()`](https://paulgovan.github.io/AutoDeskR/reference/translateObj.md),
  [`translateStl()`](https://paulgovan.github.io/AutoDeskR/reference/translateStl.md),
  and
  [`getOutputUrn()`](https://paulgovan.github.io/AutoDeskR/reference/getOutputUrn.md)
  roxygen examples.
- Fixed unreachable `vr` template branch in
  [`viewerUI()`](https://paulgovan.github.io/AutoDeskR/reference/viewerUI.md).

### Major Changes

- Updated viewer CDN URLs from deprecated `viewingservice/v1/viewers/`
  to `modelderivative/v2/viewers/7.*`. Templates also modernized to use
  `Autodesk.Viewing.GuiViewer3D` and `Document.load()` (v7 API).
- Added `req_timeout(60)` to all API requests.
- Updated all remaining “AutoDesk Forge” terminology to “AutoDesk
  Platform Services (APS)” across README, vignettes, and HTML templates.

### New Functions

- [`uploadFileSigned()`](https://paulgovan.github.io/AutoDeskR/reference/uploadFileSigned.md)
  — signed S3 URL upload supporting files of any size.

### Infrastructure

- Added `Config/testthat/edition: 3` for testthat 3rd-edition behavior.
- Added [`print()`](https://rdrr.io/r/base/print.html) S3 methods for
  all 18 response classes.
- Expanded test coverage: NULL-token guards for all functions, DELETE
  mock fixtures, `downloadFile` JSON response path.

## AutoDeskR 0.2.0

### Breaking Changes

- [`checkPdf()`](https://paulgovan.github.io/AutoDeskR/reference/checkPdf.md):
  The `source` and `destination` parameters are now deprecated. Pass the
  WorkItem `id` (from `makePdf()$content$id`) as the new `id` parameter
  instead. Using the old parameters issues a deprecation warning.

### Major Changes

- Migrated HTTP backend from `httr` to `httr2`. All HTTP errors now
  raise R errors rather than warnings.
- Authentication updated from the deprecated v1 endpoint
  (`/authentication/v1/authenticate`, end-of-life May 2024) to the v2
  endpoint (`/authentication/v2/token`).
- Design Automation API updated from the retired AutoCAD.io v2 endpoint
  to the Design Automation v3 API (`/da/us-east/v3/workitems`).
- [`downloadFile()`](https://paulgovan.github.io/AutoDeskR/reference/downloadFile.md):
  Added optional `destfile` parameter and correct handling of binary
  (non-JSON) responses.
- Bug fix:
  [`viewerUI()`](https://paulgovan.github.io/AutoDeskR/reference/viewerUI.md)
  `viewerType` validation logic was always evaluating to `TRUE`;
  corrected to properly reject invalid types.

### New Functions

- [`listBuckets()`](https://paulgovan.github.io/AutoDeskR/reference/listBuckets.md)
  — list all app-managed buckets.
- [`deleteBucket()`](https://paulgovan.github.io/AutoDeskR/reference/deleteBucket.md)
  — delete an app-managed bucket.
- [`listObjects()`](https://paulgovan.github.io/AutoDeskR/reference/listObjects.md)
  — list objects stored in a bucket.
- [`deleteObject()`](https://paulgovan.github.io/AutoDeskR/reference/deleteObject.md)
  — delete an object from a bucket.
- [`translateStl()`](https://paulgovan.github.io/AutoDeskR/reference/translateStl.md)
  — translate a design file into STL format.

### Infrastructure

- Added a `testthat` + `httptest2` test suite covering input validation
  and mocked API responses. No real AutoDesk credentials are required to
  run tests.

## AutoDeskR 0.1.5

CRAN release: 2024-09-10

### Minor Improvements and Bug Fixes

## AutoDeskR 0.1.3

CRAN release: 2017-07-09

### Major Changes

- WebVR support
