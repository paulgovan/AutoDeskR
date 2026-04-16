# Changelog

## AutoDeskR 0.3.0

### Bug Fixes

- Fixed `<-` arrow-assignment bugs in
  [`getData()`](http://paulgovan.github.io/AutoDeskR/reference/getData.md),
  [`getObjectTree()`](http://paulgovan.github.io/AutoDeskR/reference/getObjectTree.md),
  [`translateObj()`](http://paulgovan.github.io/AutoDeskR/reference/translateObj.md),
  [`translateStl()`](http://paulgovan.github.io/AutoDeskR/reference/translateStl.md),
  and
  [`getOutputUrn()`](http://paulgovan.github.io/AutoDeskR/reference/getOutputUrn.md)
  roxygen examples.
- Fixed unreachable `vr` template branch in
  [`viewerUI()`](http://paulgovan.github.io/AutoDeskR/reference/viewerUI.md).

### Major Changes

- Updated viewer CDN URLs from deprecated `viewingservice/v1/viewers/`
  to `modelderivative/v2/viewers/7.*`. Templates also modernized to use
  `Autodesk.Viewing.GuiViewer3D` and `Document.load()` (v7 API).
- Added `req_timeout(60)` to all API requests.
- Updated all remaining “AutoDesk Forge” terminology to “AutoDesk
  Platform Services (APS)” across README, vignettes, and HTML templates.

### New Functions

- [`uploadFileSigned()`](http://paulgovan.github.io/AutoDeskR/reference/uploadFileSigned.md)
  — signed S3 URL upload supporting files of any size.

### Infrastructure

- Added `Config/testthat/edition: 3` for testthat 3rd-edition behavior.
- Added [`print()`](https://rdrr.io/r/base/print.html) S3 methods for
  all 18 response classes.
- Expanded test coverage: NULL-token guards for all functions, DELETE
  mock fixtures, `downloadFile` JSON response path.

## AutoDeskR 0.2.0

### Breaking Changes

- [`checkPdf()`](http://paulgovan.github.io/AutoDeskR/reference/checkPdf.md):
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
- [`downloadFile()`](http://paulgovan.github.io/AutoDeskR/reference/downloadFile.md):
  Added optional `destfile` parameter and correct handling of binary
  (non-JSON) responses.
- Bug fix:
  [`viewerUI()`](http://paulgovan.github.io/AutoDeskR/reference/viewerUI.md)
  `viewerType` validation logic was always evaluating to `TRUE`;
  corrected to properly reject invalid types.

### New Functions

- [`listBuckets()`](http://paulgovan.github.io/AutoDeskR/reference/listBuckets.md)
  — list all app-managed buckets.
- [`deleteBucket()`](http://paulgovan.github.io/AutoDeskR/reference/deleteBucket.md)
  — delete an app-managed bucket.
- [`listObjects()`](http://paulgovan.github.io/AutoDeskR/reference/listObjects.md)
  — list objects stored in a bucket.
- [`deleteObject()`](http://paulgovan.github.io/AutoDeskR/reference/deleteObject.md)
  — delete an object from a bucket.
- [`translateStl()`](http://paulgovan.github.io/AutoDeskR/reference/translateStl.md)
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
