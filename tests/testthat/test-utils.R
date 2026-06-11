library(testthat)
library(AutoDeskR)

# aps_request ---------------------------------------------------------------

test_that("aps_request builds a request with the correct URL", {
  req <- AutoDeskR:::aps_request("https://example.com")
  expect_s3_class(req, "httr2_request")
  expect_equal(req$url, "https://example.com")
})

test_that("aps_request adds Authorization header when token is provided", {
  req <- AutoDeskR:::aps_request("https://example.com", token = "mytoken")
  # httr2 redacts Authorization values as a security measure; check presence via names()
  expect_true("Authorization" %in% names(req$headers))
})

test_that("aps_request omits Authorization header when token is NULL", {
  req <- AutoDeskR:::aps_request("https://example.com", token = NULL)
  expect_false("Authorization" %in% names(req$headers))
})

test_that("aps_request sets explicit HTTP method", {
  req <- AutoDeskR:::aps_request("https://example.com", method = "POST")
  expect_equal(req$method, "POST")
})

test_that("aps_request leaves method unset (GET default) when method = 'GET'", {
  req <- AutoDeskR:::aps_request("https://example.com", method = "GET")
  # httr2 uses NULL to represent the default GET method
  expect_true(is.null(req$method) || req$method == "GET")
})

# new_aps_token -------------------------------------------------------------

test_that("new_aps_token creates a correctly structured aps_token", {
  parsed <- list(access_token = "tok123", token_type = "Bearer", expires_in = 3600L)
  result <- AutoDeskR:::new_aps_token(parsed, "https://example.com", list())
  expect_s3_class(result, "aps_token")
  expect_s3_class(result, "getToken")
  expect_equal(result$access_token, "tok123")
  expect_equal(result$token_type,   "Bearer")
  expect_equal(result$expires_in,   3600L)
  expect_equal(result$path,         "https://example.com")
  expect_true(result$expires_at > Sys.time())
  expect_true(result$fetched_at <= Sys.time())
})

test_that("new_aps_token sets expires_at roughly expires_in - 60 seconds ahead", {
  parsed <- list(access_token = "tok", token_type = "Bearer", expires_in = 3600L)
  before <- Sys.time()
  result <- AutoDeskR:::new_aps_token(parsed, "https://example.com", list())
  after  <- Sys.time()
  expect_gte(as.numeric(result$expires_at - before, units = "secs"), 3600 - 60 - 1)
  expect_lte(as.numeric(result$expires_at - after,  units = "secs"), 3600 - 60 + 1)
})

# .resolve_token ------------------------------------------------------------

test_that(".resolve_token returns plain strings unchanged", {
  expect_equal(AutoDeskR:::.resolve_token("mytoken"), "mytoken")
})

test_that(".resolve_token extracts access_token from a valid aps_token", {
  tok <- structure(
    list(access_token = "abc123", expires_at = Sys.time() + 3600),
    class = c("aps_token", "getToken")
  )
  expect_equal(AutoDeskR:::.resolve_token(tok), "abc123")
})

test_that(".resolve_token warns when aps_token is expired", {
  tok <- structure(
    list(access_token = "abc123", expires_at = Sys.time() - 1),
    class = c("aps_token", "getToken")
  )
  expect_warning(AutoDeskR:::.resolve_token(tok), "expired")
})

test_that(".resolve_token still returns the token string when expired", {
  tok <- structure(
    list(access_token = "abc123", expires_at = Sys.time() - 1),
    class = c("aps_token", "getToken")
  )
  result <- suppressWarnings(AutoDeskR:::.resolve_token(tok))
  expect_equal(result, "abc123")
})

# aps_perform ---------------------------------------------------------------

test_that("aps_perform returns the response object on success", {
  mock_resp <- structure(list(status_code = 200L), class = "httr2_response")
  local_mocked_bindings(
    req_perform = function(req, ...) mock_resp,
    .package = "AutoDeskR"
  )
  result <- AutoDeskR:::aps_perform(httr2::request("https://example.com"))
  expect_equal(result, mock_resp)
})

test_that("aps_perform converts httr2_http errors into aps_error conditions", {
  mock_resp <- structure(list(status_code = 401L), class = "httr2_response")
  mock_err  <- structure(
    list(message = "HTTP 401 Unauthorized", resp = mock_resp),
    class = c("httr2_http_401", "httr2_http", "error", "condition")
  )
  local_mocked_bindings(
    req_perform    = function(req, ...) stop(mock_err),
    resp_body_json = function(resp, ...) list(message = "Unauthorized"),
    resp_status    = function(resp, ...) 401L,
    .package = "AutoDeskR"
  )
  err <- tryCatch(
    AutoDeskR:::aps_perform(httr2::request("https://example.com")),
    aps_error = function(e) e
  )
  expect_s3_class(err, "aps_error")
  expect_equal(err$status, 401L)
  expect_match(err$message, "401")
  expect_match(err$message, "Unauthorized")
})

test_that("aps_perform falls back to conditionMessage when body has no message field", {
  mock_resp <- structure(list(status_code = 500L), class = "httr2_response")
  mock_err  <- structure(
    list(message = "Internal Server Error", resp = mock_resp),
    class = c("httr2_http_500", "httr2_http", "error", "condition")
  )
  local_mocked_bindings(
    req_perform    = function(req, ...) stop(mock_err),
    resp_body_json = function(resp, ...) list(),   # no message or reason
    resp_status    = function(resp, ...) 500L,
    .package = "AutoDeskR"
  )
  err <- tryCatch(
    AutoDeskR:::aps_perform(httr2::request("https://example.com")),
    aps_error = function(e) e
  )
  expect_s3_class(err, "aps_error")
  expect_equal(err$status, 500L)
  expect_match(err$message, "Internal Server Error")
})

test_that("aps_perform handles non-JSON error body gracefully", {
  mock_resp <- structure(list(status_code = 500L), class = "httr2_response")
  mock_err  <- structure(
    list(message = "HTTP 500 Internal Server Error", resp = mock_resp),
    class = c("httr2_http_500", "httr2_http", "error", "condition")
  )
  local_mocked_bindings(
    req_perform    = function(req, ...) stop(mock_err),
    resp_body_json = function(resp, ...) stop("invalid JSON"),
    resp_status    = function(resp, ...) 500L,
    .package = "AutoDeskR"
  )
  err <- tryCatch(
    AutoDeskR:::aps_perform(httr2::request("https://example.com")),
    aps_error = function(e) e
  )
  expect_s3_class(err, "aps_error")
  expect_equal(err$status, 500L)
  expect_match(conditionMessage(err), "Internal Server Error")
})

test_that("aps_perform uses reason field when message field is absent", {
  mock_resp <- structure(list(status_code = 403L), class = "httr2_response")
  mock_err  <- structure(
    list(message = "HTTP 403", resp = mock_resp),
    class = c("httr2_http_403", "httr2_http", "error", "condition")
  )
  local_mocked_bindings(
    req_perform    = function(req, ...) stop(mock_err),
    resp_body_json = function(resp, ...) list(reason = "Forbidden"),
    resp_status    = function(resp, ...) 403L,
    .package = "AutoDeskR"
  )
  err <- tryCatch(
    AutoDeskR:::aps_perform(httr2::request("https://example.com")),
    aps_error = function(e) e
  )
  expect_match(err$message, "Forbidden")
})

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

test_that("waitForFile returns immediately when checkFile reports success", {
  mock_resp <- structure(
    list(content = list(status = "success"), path = "x", response = list()),
    class = "checkFile"
  )
  local_mocked_bindings(
    checkFile = function(...) mock_resp,
    .package = "AutoDeskR"
  )
  result <- waitForFile("SOME_URN", "some_token", verbose = FALSE)
  expect_s3_class(result, "checkFile")
  expect_equal(result$content$status, "success")
})

test_that("waitForFile returns on failed status", {
  mock_resp <- structure(
    list(content = list(status = "failed"), path = "x", response = list()),
    class = "checkFile"
  )
  local_mocked_bindings(
    checkFile = function(...) mock_resp,
    .package = "AutoDeskR"
  )
  result <- waitForFile("SOME_URN", "some_token", verbose = FALSE)
  expect_equal(result$content$status, "failed")
})

test_that("waitForFile times out when status never reaches a terminal state", {
  mock_resp <- structure(
    list(content = list(status = "inprogress"), path = "x", response = list()),
    class = "checkFile"
  )
  local_mocked_bindings(
    checkFile = function(...) mock_resp,
    .package = "AutoDeskR"
  )
  expect_error(
    waitForFile("SOME_URN", "some_token", interval = 0, timeout = -1, verbose = FALSE),
    "timed out"
  )
})

test_that("waitForFile via httptest2 returns on first poll when status is success", {
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

test_that("waitForWorkItem returns immediately when checkPdf reports success", {
  mock_resp <- structure(
    list(content = list(status = "success"), path = "x", response = list()),
    class = "checkPdf"
  )
  local_mocked_bindings(
    checkPdf = function(...) mock_resp,
    .package = "AutoDeskR"
  )
  result <- waitForWorkItem("wi-001", "some_token", verbose = FALSE)
  expect_s3_class(result, "checkPdf")
  expect_equal(result$content$status, "success")
})

test_that("waitForWorkItem keeps polling while status is inprogress then returns", {
  call_count <- 0L
  local_mocked_bindings(
    checkPdf = function(...) {
      call_count <<- call_count + 1L
      status <- if (call_count < 3L) "inprogress" else "success"
      structure(list(content = list(status = status), path = "x", response = list()),
                class = "checkPdf")
    },
    .package = "AutoDeskR"
  )
  result <- waitForWorkItem("wi-001", "some_token", interval = 0, verbose = FALSE)
  expect_equal(result$content$status, "success")
  expect_equal(call_count, 3L)
})

test_that("waitForWorkItem times out when status never leaves inprogress", {
  mock_resp <- structure(
    list(content = list(status = "inprogress"), path = "x", response = list()),
    class = "checkPdf"
  )
  local_mocked_bindings(
    checkPdf = function(...) mock_resp,
    .package = "AutoDeskR"
  )
  expect_error(
    waitForWorkItem("wi-001", "some_token", interval = 0, timeout = -1, verbose = FALSE),
    "timed out"
  )
})

test_that("waitForWorkItem via httptest2 returns on first poll when status is success", {
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

test_that("as_tibble.listBuckets converts a multi-bucket response to a tibble", {
  skip_if_not_installed("tibble")
  resp <- structure(
    list(content = list(items = list(
      list(bucketKey = "b1", bucketOwner = "owner1", policyKey = "transient"),
      list(bucketKey = "b2", bucketOwner = "owner2", policyKey = "persistent")
    )), path = "x", response = list()),
    class = "listBuckets"
  )
  tbl <- tibble::as_tibble(resp)
  expect_s3_class(tbl, "tbl_df")
  expect_named(tbl, c("bucketKey", "bucketOwner", "policyKey"))
  expect_equal(nrow(tbl), 2L)
  expect_equal(tbl$bucketKey, c("b1", "b2"))
  expect_equal(tbl$policyKey, c("transient", "persistent"))
})

test_that("as_tibble.listBuckets returns a zero-row tibble for empty items", {
  skip_if_not_installed("tibble")
  resp <- structure(
    list(content = list(items = list()), path = "x", response = list()),
    class = "listBuckets"
  )
  tbl <- tibble::as_tibble(resp)
  expect_s3_class(tbl, "tbl_df")
  expect_equal(nrow(tbl), 0L)
  expect_named(tbl, c("bucketKey", "bucketOwner", "policyKey"))
})

test_that("as_tibble.listBuckets via httptest2 returns a tibble with correct columns", {
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
  skip_if(requireNamespace("tibble", quietly = TRUE), "tibble is installed")
  expect_error(tibble::as_tibble(resp), "Package 'tibble' needed")
})

# as_tibble.listObjects -----------------------------------------------------

test_that("as_tibble.listObjects converts a multi-object response to a tibble", {
  skip_if_not_installed("tibble")
  resp <- structure(
    list(content = list(items = list(
      list(objectKey = "aerial.dwg",  objectId = "id1", size = 1024L,  location = "loc1"),
      list(objectKey = "model.rvt",   objectId = "id2", size = 20480L, location = "loc2")
    )), path = "x", response = list()),
    class = "listObjects"
  )
  tbl <- tibble::as_tibble(resp)
  expect_s3_class(tbl, "tbl_df")
  expect_named(tbl, c("objectKey", "objectId", "size", "location"))
  expect_equal(nrow(tbl), 2L)
  expect_equal(tbl$objectKey, c("aerial.dwg", "model.rvt"))
  expect_equal(tbl$size, c(1024L, 20480L))
})

test_that("as_tibble.listObjects returns a zero-row tibble for empty items", {
  skip_if_not_installed("tibble")
  resp <- structure(
    list(content = list(items = list()), path = "x", response = list()),
    class = "listObjects"
  )
  tbl <- tibble::as_tibble(resp)
  expect_equal(nrow(tbl), 0L)
  expect_named(tbl, c("objectKey", "objectId", "size", "location"))
})

test_that("waitForFile continues polling after a transient error", {
  call_count <- 0L
  local_mocked_bindings(
    checkFile = function(...) {
      call_count <<- call_count + 1L
      if (call_count == 1L) stop("transient network error")
      structure(list(content = list(status = "success"), path = "x", response = list()),
                class = "checkFile")
    },
    .package = "AutoDeskR"
  )
  expect_no_error(
    waitForFile("test_urn", "test_token", interval = 0, timeout = 10, verbose = FALSE)
  )
  expect_gte(call_count, 2L)
})

test_that("waitForWorkItem continues polling after a transient error", {
  call_count <- 0L
  local_mocked_bindings(
    checkPdf = function(...) {
      call_count <<- call_count + 1L
      if (call_count == 1L) stop("transient network error")
      structure(list(content = list(status = "success"), path = "x", response = list()),
                class = "checkPdf")
    },
    .package = "AutoDeskR"
  )
  expect_no_error(
    waitForWorkItem("test_id", "test_token", interval = 0, timeout = 10, verbose = FALSE)
  )
  expect_gte(call_count, 2L)
})

test_that("as_tibble.listObjects via httptest2 returns a tibble with correct columns", {
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
