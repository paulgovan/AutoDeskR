library(testthat)
library(AutoDeskR)

# createPhotoscene ----------------------------------------------------------

test_that("createPhotoscene stops when name is NULL", {
  expect_error(createPhotoscene(name = NULL, token = "t"), "name is null")
})

test_that("createPhotoscene stops when token is NULL", {
  expect_error(createPhotoscene(name = "scene", token = NULL), "token is null")
})

test_that("createPhotoscene returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- createPhotoscene(name = "my-scene", format = "obj", token = "test_token")
    expect_s3_class(resp, "createPhotoscene")
    expect_named(resp, c("content", "path", "response"))
    expect_equal(resp$content$photoscene$photosceneid, "PHOTOSCENE_ID")
    expect_equal(resp$content$photoscene$scenename, "my-scene")
  })
})

# uploadImages --------------------------------------------------------------

test_that("uploadImages stops when photoscene_id is NULL", {
  expect_error(uploadImages(photoscene_id = NULL, files = "f.jpg", token = "t"), "photoscene_id is null")
})

test_that("uploadImages stops when files is NULL", {
  expect_error(uploadImages(photoscene_id = "p", files = NULL, token = "t"), "files is null")
})

test_that("uploadImages stops when token is NULL", {
  expect_error(uploadImages(photoscene_id = "p", files = "f.jpg", token = NULL), "token is null")
})

# processPhotoscene ---------------------------------------------------------

test_that("processPhotoscene stops when photoscene_id is NULL", {
  expect_error(processPhotoscene(photoscene_id = NULL, token = "t"), "photoscene_id is null")
})

test_that("processPhotoscene stops when token is NULL", {
  expect_error(processPhotoscene(photoscene_id = "p", token = NULL), "token is null")
})

test_that("processPhotoscene returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- processPhotoscene(photoscene_id = "PHOTOSCENE_ID", token = "test_token")
    expect_s3_class(resp, "processPhotoscene")
    expect_named(resp, c("content", "path", "response"))
    expect_equal(resp$content$photoscene$photosceneid, "PHOTOSCENE_ID")
  })
})

# checkPhotoscene -----------------------------------------------------------

test_that("checkPhotoscene stops when photoscene_id is NULL", {
  expect_error(checkPhotoscene(photoscene_id = NULL, token = "t"), "photoscene_id is null")
})

test_that("checkPhotoscene stops when token is NULL", {
  expect_error(checkPhotoscene(photoscene_id = "p", token = NULL), "token is null")
})

test_that("checkPhotoscene returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- checkPhotoscene(photoscene_id = "PHOTOSCENE_ID", token = "test_token")
    expect_s3_class(resp, "checkPhotoscene")
    expect_named(resp, c("content", "path", "response"))
    expect_equal(resp$content$photoscene$progress, "100")
  })
})

# waitForPhotoscene ---------------------------------------------------------

test_that("waitForPhotoscene returns when progress is 100", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- waitForPhotoscene("PHOTOSCENE_ID", "test_token", verbose = FALSE)
    expect_s3_class(resp, "checkPhotoscene")
    expect_equal(resp$content$photoscene$progress, "100")
  })
})
