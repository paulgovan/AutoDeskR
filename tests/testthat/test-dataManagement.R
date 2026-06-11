library(testthat)
library(AutoDeskR)

# makeBucket ----------------------------------------------------------------

test_that("makeBucket stops when token is NULL", {
  expect_error(makeBucket(token = NULL), "token is null")
})

test_that("makeBucket stops when bucket is NULL", {
  expect_error(makeBucket(token = "t", bucket = NULL), "bucket is null")
})

test_that("makeBucket stops when policy is NULL", {
  expect_error(makeBucket(token = "t", bucket = "b", policy = NULL), "policy is null")
})

test_that("makeBucket returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- makeBucket(token = "test_token", bucket = "mybucket", policy = "transient")
    expect_s3_class(resp, "makeBucket")
    expect_named(resp, c("content", "path", "response"))
    expect_equal(resp$content$bucketKey, "mybucket")
    expect_equal(resp$content$policyKey, "transient")
  })
})

# checkBucket ---------------------------------------------------------------

test_that("checkBucket stops when token is NULL", {
  expect_error(checkBucket(token = NULL), "token is null")
})

test_that("checkBucket stops when bucket is NULL", {
  expect_error(checkBucket(token = "t", bucket = NULL), "bucket is null")
})

test_that("checkBucket returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- checkBucket(token = "test_token", bucket = "mybucket")
    expect_s3_class(resp, "checkBucket")
    expect_equal(resp$content$bucketKey, "mybucket")
  })
})

# listBuckets ---------------------------------------------------------------

test_that("listBuckets stops when token is NULL", {
  expect_error(listBuckets(token = NULL), "token is null")
})

test_that("listBuckets returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- listBuckets(token = "test_token")
    expect_s3_class(resp, "listBuckets")
    expect_named(resp, c("content", "path", "response"))
    expect_true(!is.null(resp$content$items))
    expect_equal(resp$content$items[[1]]$bucketKey, "mybucket")
  })
})

# listObjects ---------------------------------------------------------------

test_that("listObjects stops when token is NULL", {
  expect_error(listObjects(token = NULL), "token is null")
})

test_that("listObjects stops when bucket is NULL", {
  expect_error(listObjects(token = "t", bucket = NULL), "bucket is null")
})

test_that("listObjects returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- listObjects(token = "test_token", bucket = "mybucket")
    expect_s3_class(resp, "listObjects")
    expect_equal(resp$content$items[[1]]$objectKey, "aerial.dwg")
  })
})

# uploadFile ----------------------------------------------------------------

test_that("uploadFile stops when file is NULL", {
  expect_error(uploadFile(file = NULL, token = "t"), "file is null")
})

test_that("uploadFile stops when token is NULL", {
  expect_error(uploadFile(file = "f.dwg", token = NULL), "token is null")
})

test_that("uploadFile returns correct structure", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  file_path <- file.path(tempdir(), "test.txt")
  writeLines("hello", file_path)
  on.exit(unlink(file_path), add = TRUE)
  httptest2::with_mock_api({
    resp <- uploadFile(file = file_path, token = "test_token", bucket = "mybucket")
    expect_s3_class(resp, "uploadFile")
    expect_named(resp, c("content", "path", "response"))
    expect_equal(resp$content$bucketKey, "mybucket")
    expect_equal(resp$content$objectKey, "test.txt")
  })
})

# uploadFileSigned ----------------------------------------------------------

test_that("uploadFileSigned stops when file is NULL", {
  expect_error(uploadFileSigned(file = NULL, token = "t"), "file is null")
})

test_that("uploadFileSigned stops when token is NULL", {
  expect_error(uploadFileSigned(file = "big.rvt", token = NULL), "token is null")
})

test_that("uploadFileSigned stops when bucket is NULL", {
  expect_error(uploadFileSigned(file = "big.rvt", token = "t", bucket = NULL), "bucket is null")
})

test_that("uploadFileSigned returns correct structure", {
  skip_on_cran()
  tmp <- file.path(tempdir(), "test.txt")
  writeLines("hello", tmp)
  on.exit(unlink(tmp), add = TRUE)
  aps_call_count <- 0L
  local_mocked_bindings(
    aps_perform = function(req, ...) {
      aps_call_count <<- aps_call_count + 1L
      structure(list(status_code = 200L, call_num = aps_call_count), class = "httr2_response")
    },
    resp_body_json = function(resp, ...) {
      if (isTRUE(resp$call_num == 1L)) {
        list(uploadKey = "test-upload-key-abc123",
             urls = list("https://s3.amazonaws.com/autodesk-test/test.txt?signed=1"))
      } else {
        list(bucketKey = "mybucket", objectKey = "test.txt", size = 5L,
             objectId = "urn:adsk.objects:os.object:mybucket/test.txt",
             contentType = "application/octet-stream")
      }
    },
    req_perform = function(req, ...) structure(list(status_code = 200L), class = "httr2_response"),
    .package = "AutoDeskR"
  )
  resp <- uploadFileSigned(file = tmp, token = "test_token", bucket = "mybucket")
  expect_s3_class(resp, "uploadFileSigned")
  expect_named(resp, c("content", "path", "response"))
  expect_equal(resp$content$objectKey, "test.txt")
  expect_equal(aps_call_count, 2L)
})

# deleteBucket / deleteObject -----------------------------------------------

test_that("deleteBucket stops when token is NULL", {
  expect_error(deleteBucket(token = NULL), "token is null")
})

test_that("deleteBucket returns status on success", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- deleteBucket(token = "test_token", bucket = "mybucket")
    expect_s3_class(resp, "deleteBucket")
    expect_equal(resp$content$status, 200L)
  })
})

test_that("deleteObject stops when object is NULL", {
  expect_error(deleteObject(token = "t", bucket = "b", object = NULL), "object is null")
})

test_that("deleteObject stops when token is NULL", {
  expect_error(deleteObject(token = NULL, bucket = "b", object = "f.dwg"), "token is null")
})

test_that("deleteObject returns status on success", {
  skip_on_cran()
  skip_if_not(dir.exists(test_path("developer.api.autodesk.com")), "mock fixtures not available")
  skip_if_not_installed("httptest2")
  httptest2::with_mock_api({
    resp <- deleteObject(token = "test_token", bucket = "mybucket", object = "aerial.dwg")
    expect_s3_class(resp, "deleteObject")
    expect_equal(resp$content$status, 200L)
  })
})
