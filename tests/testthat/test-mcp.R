skip_on_cran()
skip_if_not_installed("ellmer")

# Helper: build a minimal aps_token object for use in tests.
# Set expired = TRUE to simulate a token past its expiry time.
make_fake_token <- function(expired = FALSE) {
  structure(
    list(
      access_token = "test_tok",
      token_type   = "Bearer",
      expires_in   = 3600L,
      expires_at   = Sys.time() + if (expired) -100 else 3600,
      fetched_at   = Sys.time(),
      path         = "https://developer.api.autodesk.com/authentication/v2/token",
      response     = list()
    ),
    class = c("aps_token", "getToken")
  )
}

# ---- Tool list structure ------------------------------------------------

test_that("autodeskr_mcp_tools() returns 21 named ellmer tools", {
  tools <- autodeskr_mcp_tools()

  expect_type(tools, "list")
  expect_length(tools, 21)

  expected_names <- c(
    "get_token",
    "make_bucket", "check_bucket", "list_buckets",
    "upload_file", "list_objects", "delete_object",
    "translate_svf", "translate_svf2", "check_file",
    "get_metadata", "get_data", "get_object_tree",
    "get_output_urn", "download_file",
    "make_pdf", "check_pdf",
    "create_photoscene", "upload_images",
    "process_photoscene", "check_photoscene"
  )
  expect_named(tools, expected_names)

  # ellmer ToolDef extends function — the tool object itself is callable
  for (t in tools) expect_true(is.function(t))
})

# ---- Credential guard ---------------------------------------------------

test_that(".aps_session_token() errors when env vars are unset", {
  # Access internals directly — load_all() puts them in the test namespace
  .aps_token_cache$token <- NULL
  withr::with_envvar(c(APS_CLIENT_ID = NA, APS_CLIENT_SECRET = NA), {
    expect_error(.aps_session_token(), "APS_CLIENT_ID")
  })
})

# ---- Token cache logic --------------------------------------------------

test_that(".aps_session_token() reuses cached token when not expired", {
  call_count <- 0L
  local_mocked_bindings(
    getToken   = function(...) { call_count <<- call_count + 1L; make_fake_token() },
    is_expired = function(tok) FALSE,
    .package   = "AutoDeskR"
  )
  .aps_token_cache$token <- NULL
  withr::with_envvar(c(APS_CLIENT_ID = "id", APS_CLIENT_SECRET = "sec"), {
    .aps_session_token()
    .aps_session_token()
  })
  expect_equal(call_count, 1L)
})

test_that(".aps_session_token() refreshes when cached token is expired", {
  call_count <- 0L
  local_mocked_bindings(
    getToken   = function(...) { call_count <<- call_count + 1L; make_fake_token() },
    is_expired = function(tok) TRUE,
    .package   = "AutoDeskR"
  )
  .aps_token_cache$token <- make_fake_token(expired = TRUE)
  withr::with_envvar(c(APS_CLIENT_ID = "id", APS_CLIENT_SECRET = "sec"), {
    .aps_session_token()
  })
  expect_equal(call_count, 1L)
})

# ---- .mcp_result() helper -----------------------------------------------

test_that(".mcp_result() returns content and path but not response", {
  fake   <- list(content = list(a = 1), path = "https://x.com", response = list(raw = TRUE))
  result <- .mcp_result(fake)

  expect_named(result, c("content", "path"))
  expect_null(result$response)
  expect_equal(result$content$a, 1)
  expect_equal(result$path, "https://x.com")
})

# ---- Tool wrapper delegation --------------------------------------------

test_that("list_buckets tool passes limit and region to listBuckets()", {
  called_with <- list()
  local_mocked_bindings(
    listBuckets = function(token, limit, region) {
      called_with <<- list(limit = limit, region = region)
      structure(list(content = list(), path = "x", response = list()),
                class = "listBuckets")
    },
    is_expired = function(tok) FALSE,
    .package   = "AutoDeskR"
  )
  .aps_token_cache$token <- make_fake_token()

  tools <- autodeskr_mcp_tools()
  tools$list_buckets(limit = 5L, region = "EMEA")

  expect_equal(called_with$limit, 5L)
  expect_equal(called_with$region, "EMEA")
})

test_that("translate_svf2 tool splits comma-separated views into a character vector", {
  captured_views <- NULL
  local_mocked_bindings(
    translateSvf2 = function(urn, token, views) {
      captured_views <<- views
      structure(list(content = list(), path = "x", response = list()),
                class = "translateSvf2")
    },
    is_expired = function(tok) FALSE,
    .package   = "AutoDeskR"
  )
  .aps_token_cache$token <- make_fake_token()

  tools <- autodeskr_mcp_tools()
  tools$translate_svf2(urn = "abc123", views = "2d, 3d")

  expect_equal(captured_views, c("2d", "3d"))
})

test_that("upload_images tool splits comma-separated file paths into a character vector", {
  captured_files <- NULL
  local_mocked_bindings(
    uploadImages = function(photoscene_id, files, token) {
      captured_files <<- files
      structure(list(content = list(), path = "x", response = list()),
                class = "uploadImages")
    },
    is_expired = function(tok) FALSE,
    .package   = "AutoDeskR"
  )
  .aps_token_cache$token <- make_fake_token()

  tools <- autodeskr_mcp_tools()
  tools$upload_images(photoscene_id = "ps1", files = "/a/b.jpg, /c/d.png")

  expect_equal(captured_files, c("/a/b.jpg", "/c/d.png"))
})
