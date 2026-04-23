# AutoDeskR 0.4.0

## New Functions

* `translateSvf2()` — translate design files to SVF2 format (~30% smaller than
  SVF, faster rendering in the Viewer).
* `createPhotoscene()`, `uploadImages()`, `processPhotoscene()`,
  `checkPhotoscene()` — Reality Capture API for photogrammetry and 3D model
  generation from images.
* `waitForFile()` — poll `checkFile()` until a Model Derivative translation
  completes.
* `waitForWorkItem()` — poll `checkPdf()` until a Design Automation WorkItem
  completes.
* `is_expired()` — check whether an `aps_token` has expired.
* `aps_error()` — structured S3 error condition for APS API failures; catch
  with `tryCatch(..., aps_error = function(e) ...)`.

## Improvements

* `getToken()` now returns an `aps_token` object with expiry tracking
  (`$expires_at`, `is_expired()`). Existing code using
  `resp$content$access_token` continues to work unchanged.
* All API functions now accept an `aps_token` object in place of a raw token
  string. Expired tokens trigger a warning.
* API errors now include decoded JSON messages from APS rather than raw HTTP
  error text.
* `as_tibble()` methods added for `listBuckets` and `listObjects` response
  objects (requires the `tibble` package).

## Infrastructure

* Minimum R version bumped from 2.10.0 to 4.1.0.
* `tibble` added to `Suggests`.

# AutoDeskR 0.3.0

## Bug Fixes
* Fixed `<-` arrow-assignment bugs in `getData()`, `getObjectTree()`,
  `translateObj()`, `translateStl()`, and `getOutputUrn()` roxygen examples.
* Fixed unreachable `vr` template branch in `viewerUI()`.

## Major Changes
* Updated viewer CDN URLs from deprecated `viewingservice/v1/viewers/` to
  `modelderivative/v2/viewers/7.*`. Templates also modernized to use
  `Autodesk.Viewing.GuiViewer3D` and `Document.load()` (v7 API).
* Added `req_timeout(60)` to all API requests.
* Updated all remaining "AutoDesk Forge" terminology to "AutoDesk Platform
  Services (APS)" across README, vignettes, and HTML templates.

## New Functions
* `uploadFileSigned()` — signed S3 URL upload supporting files of any size.

## Infrastructure
* Added `Config/testthat/edition: 3` for testthat 3rd-edition behavior.
* Added `print()` S3 methods for all 18 response classes.
* Expanded test coverage: NULL-token guards for all functions, DELETE mock
  fixtures, `downloadFile` JSON response path.

# AutoDeskR 0.2.0

## Breaking Changes

* `checkPdf()`: The `source` and `destination` parameters are now deprecated.
  Pass the WorkItem `id` (from `makePdf()$content$id`) as the new `id`
  parameter instead. Using the old parameters issues a deprecation warning.

## Major Changes

* Migrated HTTP backend from `httr` to `httr2`. All HTTP errors now raise R
  errors rather than warnings.
* Authentication updated from the deprecated v1 endpoint
  (`/authentication/v1/authenticate`, end-of-life May 2024) to the v2 endpoint
  (`/authentication/v2/token`).
* Design Automation API updated from the retired AutoCAD.io v2 endpoint to the
  Design Automation v3 API (`/da/us-east/v3/workitems`).
* `downloadFile()`: Added optional `destfile` parameter and correct handling of
  binary (non-JSON) responses.
* Bug fix: `viewerUI()` `viewerType` validation logic was always evaluating to
  `TRUE`; corrected to properly reject invalid types.

## New Functions

* `listBuckets()` — list all app-managed buckets.
* `deleteBucket()` — delete an app-managed bucket.
* `listObjects()` — list objects stored in a bucket.
* `deleteObject()` — delete an object from a bucket.
* `translateStl()` — translate a design file into STL format.

## Infrastructure

* Added a `testthat` + `httptest2` test suite covering input validation and
  mocked API responses. No real AutoDesk credentials are required to run tests.

# AutoDeskR 0.1.5

## Minor Improvements and Bug Fixes

# AutoDeskR 0.1.3

## Major Changes
* WebVR support
