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
