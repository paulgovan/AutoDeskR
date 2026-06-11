library(testthat)
library(AutoDeskR)

# viewer3D ------------------------------------------------------------------

test_that("viewer3D stops when urn is NULL", {
  expect_error(viewer3D(urn = NULL, token = "t"), "urn is null")
})

test_that("viewer3D stops when token is NULL", {
  expect_error(viewer3D(urn = "u", token = NULL), "token is null")
})

test_that("viewer3D stops when viewerType is NULL", {
  expect_error(viewer3D(urn = "u", token = "t", viewerType = NULL), "viewerType is null")
})

# viewerUI ------------------------------------------------------------------

test_that("viewerUI stops when urn is NULL", {
  expect_error(viewerUI("ns", urn = NULL, token = "t"), "urn is null")
})

test_that("viewerUI stops when token is NULL", {
  expect_error(viewerUI("ns", urn = "u", token = NULL), "token is null")
})

test_that("viewerUI stops for invalid viewerType", {
  expect_error(
    viewerUI("ns", urn = "u", token = "t", viewerType = "invalid"),
    "Please choose a viewerType"
  )
})

test_that("viewerUI stops for 'vr' viewerType (not supported in viewerUI)", {
  expect_error(
    viewerUI("ns", urn = "u", token = "t", viewerType = "vr"),
    "Please choose a viewerType"
  )
})

# viewer3D template selection ------------------------------------------------

test_that("viewer3D returns a shiny app for each viewerType", {
  skip_if_not_installed("shiny")
  app_header   <- viewer3D(urn = "test_urn", token = "test_token", viewerType = "header")
  app_headless <- viewer3D(urn = "test_urn", token = "test_token", viewerType = "headless")
  app_vr       <- viewer3D(urn = "test_urn", token = "test_token", viewerType = "vr")
  expect_s3_class(app_header,   "shiny.appobj")
  expect_s3_class(app_headless, "shiny.appobj")
  expect_s3_class(app_vr,       "shiny.appobj")
})

# viewerUI template selection ------------------------------------------------

test_that("viewerUI returns an HTML object for valid viewerTypes", {
  skip_if_not_installed("shiny")
  ui_header   <- viewerUI("viewer1", urn = "test_urn", token = "test_token", viewerType = "header")
  ui_headless <- viewerUI("viewer1", urn = "test_urn", token = "test_token", viewerType = "headless")
  expect_true(!is.null(ui_header))
  expect_true(!is.null(ui_headless))
})
