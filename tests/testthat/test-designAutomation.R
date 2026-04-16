library(testthat)
library(AutoDeskR)

# makePdf -------------------------------------------------------------------

test_that("makePdf stops when source is NULL", {
  expect_error(makePdf(source = NULL, destination = "d", token = "t"), "source is null")
})

test_that("makePdf stops when destination is NULL", {
  expect_error(makePdf(source = "s", destination = NULL, token = "t"), "destination is null")
})

test_that("makePdf stops when token is NULL", {
  expect_error(makePdf(source = "s", destination = "d", token = NULL), "token is null")
})

test_that("makePdf returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- makePdf(
      source      = "http://example.com/file.dwg",
      destination = "http://example.com/output/",
      token       = "test_token"
    )
    expect_s3_class(resp, "makePdf")
    expect_named(resp, c("content", "path", "response"))
    expect_equal(resp$content$id, "abc123")
    expect_equal(resp$content$status, "pending")
    expect_equal(resp$path, "https://developer.api.autodesk.com/da/us-east/v3/workitems")
  })
})

# checkPdf ------------------------------------------------------------------

test_that("checkPdf stops when id is NULL", {
  expect_error(checkPdf(id = NULL, token = "t"), "id is null")
})

test_that("checkPdf stops when token is NULL", {
  expect_error(checkPdf(id = "abc123", token = NULL), "token is null")
})

test_that("checkPdf returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- checkPdf(id = "abc123", token = "test_token")
    expect_s3_class(resp, "checkPdf")
    expect_equal(resp$content$id, "abc123")
    expect_equal(resp$content$status, "success")
  })
})

test_that("checkPdf warns when deprecated source is supplied", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    expect_warning(
      checkPdf(id = "abc123", token = "test_token", source = "http://x.com/f.dwg"),
      "deprecated"
    )
  })
})

test_that("checkPdf warns when deprecated destination is supplied", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    expect_warning(
      checkPdf(id = "abc123", token = "test_token", destination = "http://x.com/out/"),
      "deprecated"
    )
  })
})
