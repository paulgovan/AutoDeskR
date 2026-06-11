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

test_that("getToken accepts a single custom scope", {
  local_mocked_bindings(
    req_perform = function(req, ...) structure(list(status_code = 200L), class = "httr2_response"),
    resp_body_json = function(resp, ...) list(access_token = "tok", token_type = "Bearer", expires_in = 3600L),
    .package = "AutoDeskR"
  )
  resp <- getToken(id = "test_id", secret = "test_secret", scope = "data:read")
  expect_s3_class(resp, "aps_token")
  expect_equal(resp$access_token, "tok")
})

test_that("getToken accepts multiple space-separated scopes", {
  local_mocked_bindings(
    req_perform = function(req, ...) structure(list(status_code = 200L), class = "httr2_response"),
    resp_body_json = function(resp, ...) list(access_token = "tok", token_type = "Bearer", expires_in = 3600L),
    .package = "AutoDeskR"
  )
  resp <- getToken(id = "test_id", secret = "test_secret", scope = "data:write data:read bucket:create")
  expect_s3_class(resp, "aps_token")
  expect_equal(resp$access_token, "tok")
})

test_that("getToken passes scope string correctly to the request body", {
  captured_req <- NULL
  local_mocked_bindings(
    req_perform = function(req, ...) {
      captured_req <<- req
      structure(list(status_code = 200L), class = "httr2_response")
    },
    resp_body_json = function(resp, ...) list(access_token = "tok", token_type = "Bearer", expires_in = 3600L),
    .package = "AutoDeskR"
  )
  getToken(id = "test_id", secret = "test_secret", scope = "data:write data:read")
  expect_equal(URLdecode(as.character(captured_req$body$data$scope)), "data:write data:read")
})

test_that("getToken returns correct structure on success", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- getToken(id = "test_id", secret = "test_secret", scope = "data:read")
    expect_s3_class(resp, "aps_token")
    expect_s3_class(resp, "getToken")
    # Direct field access (new interface)
    expect_equal(resp$access_token, "test_token_abc123")
    expect_equal(resp$token_type, "Bearer")
    expect_equal(resp$path, "https://developer.api.autodesk.com/authentication/v2/token")
    # Backward-compatible $content access still works via $.aps_token shim
    expect_equal(resp$content$access_token, "test_token_abc123")
    expect_equal(resp$content$token_type, "Bearer")
  })
})
