library(testthat)
library(AutoDeskR)

# aps_error -----------------------------------------------------------------

test_that("aps_error creates condition with correct class", {
  err <- aps_error("something went wrong", status = 401L, body = list())
  expect_s3_class(err, "aps_error")
  expect_s3_class(err, "error")
  expect_s3_class(err, "condition")
})

test_that("aps_error stores message, status, and body", {
  body <- list(message = "Unauthorized", reason = "bad token")
  err  <- aps_error("APS API error (HTTP 401): Unauthorized", status = 401L, body = body)
  expect_equal(err$message, "APS API error (HTTP 401): Unauthorized")
  expect_equal(err$status,  401L)
  expect_equal(err$body,    body)
})

test_that("aps_error can be caught with tryCatch", {
  result <- tryCatch(
    stop(aps_error("oops", status = 500L, body = list())),
    aps_error = function(e) paste("caught:", e$status)
  )
  expect_equal(result, "caught: 500")
})

# is_expired ----------------------------------------------------------------

test_that("is_expired returns FALSE for a fresh token", {
  tok <- structure(
    list(
      access_token = "tok",
      token_type   = "Bearer",
      expires_in   = 3600L,
      expires_at   = Sys.time() + 3600,
      fetched_at   = Sys.time(),
      path         = "https://example.com",
      response     = list()
    ),
    class = c("aps_token", "getToken")
  )
  expect_false(is_expired(tok))
})

test_that("is_expired returns TRUE for an expired token", {
  tok <- structure(
    list(
      access_token = "tok",
      token_type   = "Bearer",
      expires_in   = 1L,
      expires_at   = Sys.time() - 1,
      fetched_at   = Sys.time() - 3601,
      path         = "https://example.com",
      response     = list()
    ),
    class = c("aps_token", "getToken")
  )
  expect_true(is_expired(tok))
})

# $.aps_token backward-compat shim -----------------------------------------

test_that("$.aps_token shim: resp$content$access_token works", {
  tok <- structure(
    list(
      access_token = "abc123",
      token_type   = "Bearer",
      expires_in   = 3600L,
      expires_at   = Sys.time() + 3600,
      fetched_at   = Sys.time(),
      path         = "https://example.com",
      response     = list()
    ),
    class = c("aps_token", "getToken")
  )
  expect_equal(tok$content$access_token, "abc123")
  expect_equal(tok$content$token_type,   "Bearer")
  expect_equal(tok$content$expires_in,   3600L)
})

test_that("$.aps_token shim: direct field access also works", {
  tok <- structure(
    list(
      access_token = "abc123",
      token_type   = "Bearer",
      expires_in   = 3600L,
      expires_at   = Sys.time() + 3600,
      fetched_at   = Sys.time(),
      path         = "https://example.com",
      response     = list()
    ),
    class = c("aps_token", "getToken")
  )
  expect_equal(tok$access_token, "abc123")
  expect_equal(tok$path, "https://example.com")
})

# waitForFile ---------------------------------------------------------------

test_that("waitForFile returns on first poll when status is success", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- waitForFile(urn = "ENCODED_URN", token = "test_token", verbose = FALSE)
    expect_s3_class(resp, "checkFile")
    expect_equal(resp$content$status, "success")
  })
})

# waitForWorkItem -----------------------------------------------------------

test_that("waitForWorkItem returns on first poll when status is success", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- waitForWorkItem(id = "abc123", token = "test_token", verbose = FALSE)
    expect_s3_class(resp, "checkPdf")
    expect_equal(resp$content$status, "success")
  })
})

# as_tibble.listBuckets -----------------------------------------------------

test_that("as_tibble.listBuckets returns a tibble with correct columns", {
  skip_on_cran()
  skip_if_not_installed("tibble")
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- listBuckets(token = "test_token")
    tbl  <- tibble::as_tibble(resp)
    expect_s3_class(tbl, "tbl_df")
    expect_named(tbl, c("bucketKey", "bucketOwner", "policyKey"))
    expect_equal(tbl$bucketKey[[1]], "mybucket")
  })
})

test_that("as_tibble.listBuckets errors without tibble", {
  resp <- structure(
    list(content = list(items = list()), path = "x", response = list()),
    class = "listBuckets"
  )
  # If tibble is available this won't error - only test the guard when tibble is absent
  skip_if(requireNamespace("tibble", quietly = TRUE), "tibble is installed")
  expect_error(tibble::as_tibble(resp), "Package 'tibble' needed")
})

# as_tibble.listObjects -----------------------------------------------------

test_that("as_tibble.listObjects returns a tibble with correct columns", {
  skip_on_cran()
  skip_if_not_installed("tibble")
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- listObjects(token = "test_token", bucket = "mybucket")
    tbl  <- tibble::as_tibble(resp)
    expect_s3_class(tbl, "tbl_df")
    expect_named(tbl, c("objectKey", "objectId", "size", "location"))
    expect_equal(tbl$objectKey[[1]], "aerial.dwg")
    expect_equal(tbl$size[[1]], 1024L)
  })
})
