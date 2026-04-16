library(testthat)
library(AutoDeskR)

test_that("getToken stops when id is NULL", {
  expect_error(getToken(id = NULL, secret = "s", scope = "data:read"), "id is null")
})

test_that("getToken stops when secret is NULL", {
  expect_error(getToken(id = "i", secret = NULL, scope = "data:read"), "secret is null")
})

test_that("getToken stops when scope is NULL", {
  expect_error(getToken(id = "i", secret = "s", scope = NULL), "scope is null")
})

test_that("getToken returns correct structure on success", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- getToken(id = "test_id", secret = "test_secret", scope = "data:read")
    expect_s3_class(resp, "getToken")
    expect_named(resp, c("content", "path", "response"))
    expect_equal(resp$content$access_token, "test_token_abc123")
    expect_equal(resp$content$token_type, "Bearer")
    expect_equal(resp$path, "https://developer.api.autodesk.com/authentication/v2/token")
  })
})
