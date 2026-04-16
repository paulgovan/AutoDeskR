library(testthat)
library(AutoDeskR)

# translateSvf --------------------------------------------------------------

test_that("translateSvf stops when urn is NULL", {
  expect_error(translateSvf(urn = NULL, token = "t"), "urn is null")
})

test_that("translateSvf stops when token is NULL", {
  expect_error(translateSvf(urn = "u", token = NULL), "token is null")
})

test_that("translateSvf returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- translateSvf(urn = "ENCODED_URN", token = "test_token")
    expect_s3_class(resp, "translateSvf")
    expect_named(resp, c("content", "path", "response"))
    expect_equal(resp$content$result, "created")
  })
})

# translateObj --------------------------------------------------------------

test_that("translateObj stops when urn is NULL", {
  expect_error(translateObj(urn = NULL, token = "t"), "urn is null")
})

test_that("translateObj stops when token is NULL", {
  expect_error(translateObj(urn = "u", token = NULL), "token is null")
})

test_that("translateObj returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- translateObj(urn = "ENCODED_URN", token = "test_token")
    expect_s3_class(resp, "translateObj")
    expect_equal(resp$content$result, "created")
  })
})

# translateStl --------------------------------------------------------------

test_that("translateStl stops when urn is NULL", {
  expect_error(translateStl(urn = NULL, token = "t"), "urn is null")
})

test_that("translateStl stops when token is NULL", {
  expect_error(translateStl(urn = "u", token = NULL), "token is null")
})

test_that("translateStl returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- translateStl(urn = "ENCODED_URN", token = "test_token")
    expect_s3_class(resp, "translateStl")
    expect_equal(resp$content$result, "created")
  })
})

# checkFile -----------------------------------------------------------------

test_that("checkFile stops when urn is NULL", {
  expect_error(checkFile(urn = NULL, token = "t"), "urn is null")
})

test_that("checkFile stops when token is NULL", {
  expect_error(checkFile(urn = "u", token = NULL), "token is null")
})

test_that("checkFile returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- checkFile(urn = "ENCODED_URN", token = "test_token")
    expect_s3_class(resp, "checkFile")
    expect_equal(resp$content$status, "success")
  })
})

# getMetadata ---------------------------------------------------------------

test_that("getMetadata stops when urn is NULL", {
  expect_error(getMetadata(urn = NULL, token = "t"), "urn is null")
})

test_that("getMetadata stops when token is NULL", {
  expect_error(getMetadata(urn = "u", token = NULL), "token is null")
})

test_that("getMetadata returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- getMetadata(urn = "ENCODED_URN", token = "test_token")
    expect_s3_class(resp, "getMetadata")
    expect_equal(resp$content$data$metadata[[1]]$guid, "test-guid-1234")
  })
})

# getOutputUrn --------------------------------------------------------------

test_that("getOutputUrn stops when urn is NULL", {
  expect_error(getOutputUrn(urn = NULL, token = "t"), "urn is null")
})

test_that("getOutputUrn returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- getOutputUrn(urn = "ENCODED_URN", token = "test_token")
    expect_s3_class(resp, "getOutputUrn")
    expect_equal(resp$content$status, "success")
  })
})

# getData / getObjectTree ---------------------------------------------------

test_that("getData stops when guid is NULL", {
  expect_error(getData(guid = NULL, urn = "u", token = "t"), "guid is null")
})

test_that("getData stops when token is NULL", {
  expect_error(getData(guid = "g", urn = "u", token = NULL), "token is null")
})

test_that("getObjectTree stops when urn is NULL", {
  expect_error(getObjectTree(guid = "g", urn = NULL, token = "t"), "urn is null")
})

test_that("getObjectTree stops when guid is NULL", {
  expect_error(getObjectTree(guid = NULL, urn = "u", token = "t"), "guid is null")
})

# downloadFile --------------------------------------------------------------

test_that("downloadFile stops when urn is NULL", {
  expect_error(downloadFile(urn = NULL, output_urn = "o", token = "t"), "urn is null")
})

test_that("downloadFile stops when output_urn is NULL", {
  expect_error(downloadFile(urn = "u", output_urn = NULL, token = "t"), "output_urn is null")
})

test_that("downloadFile stops when token is NULL", {
  expect_error(downloadFile(urn = "u", output_urn = "o", token = NULL), "token is null")
})

test_that("downloadFile returns parsed JSON when response is JSON", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- downloadFile(urn = "ENCODED_URN", output_urn = "OUTPUT_URN", token = "test_token")
    expect_s3_class(resp, "downloadFile")
    expect_named(resp, c("content", "path", "response"))
  })
})
