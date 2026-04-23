library(testthat)
library(AutoDeskR)

# Helper: build a minimal aps_token for print.aps_token
make_token <- function(expired = FALSE) {
  now <- Sys.time()
  structure(
    list(
      access_token = "tok123",
      token_type   = "Bearer",
      expires_in   = 3600L,
      expires_at   = if (expired) now - 1 else now + 3600,
      fetched_at   = now,
      path         = "https://developer.api.autodesk.com/authentication/v2/token",
      response     = list()
    ),
    class = c("aps_token", "getToken")
  )
}

# Helper: build a plain getToken response (pre-v0.4.0 shape)
make_resp <- function(cls, content) {
  structure(list(content = content, path = "https://x.com", response = list()), class = cls)
}

# print.aps_token -----------------------------------------------------------

test_that("print.aps_token shows token type and valid status", {
  expect_output(print(make_token()), "aps_token")
  expect_output(print(make_token()), "Bearer")
  expect_output(print(make_token()), "valid")
})

test_that("print.aps_token shows EXPIRED when token is expired", {
  expect_output(print(make_token(expired = TRUE)), "EXPIRED")
})

# print.getToken (legacy pre-v0.4.0 shape) ----------------------------------

test_that("print.getToken shows token type and expiry from legacy content shape", {
  r <- structure(
    list(
      content  = list(token_type = "Bearer", expires_in = 3600L),
      path     = "https://developer.api.autodesk.com/authentication/v2/token",
      response = list()
    ),
    class = "getToken"   # plain getToken, NOT c("aps_token", "getToken")
  )
  expect_output(print(r), "getToken")
  expect_output(print(r), "Bearer")
  expect_output(print(r), "3600")
})

# print.makeBucket ----------------------------------------------------------

test_that("print.makeBucket shows bucket key and policy", {
  r <- make_resp("makeBucket", list(bucketKey = "mybucket", policyKey = "transient"))
  expect_output(print(r), "makeBucket")
  expect_output(print(r), "mybucket")
  expect_output(print(r), "transient")
})

# print.checkBucket ---------------------------------------------------------

test_that("print.checkBucket shows bucket key", {
  r <- make_resp("checkBucket", list(bucketKey = "mybucket", policyKey = "persistent"))
  expect_output(print(r), "checkBucket")
  expect_output(print(r), "mybucket")
})

# print.listBuckets ---------------------------------------------------------

test_that("print.listBuckets shows count and bucket name", {
  r <- make_resp("listBuckets", list(items = list(list(bucketKey = "mybucket"))))
  expect_output(print(r), "listBuckets")
  expect_output(print(r), "1")
  expect_output(print(r), "mybucket")
})

test_that("print.listBuckets handles empty list", {
  r <- make_resp("listBuckets", list(items = list()))
  expect_output(print(r), "0")
})

# print.deleteBucket --------------------------------------------------------

test_that("print.deleteBucket shows status", {
  r <- make_resp("deleteBucket", list(status = 200L))
  expect_output(print(r), "deleteBucket")
  expect_output(print(r), "200")
})

# print.uploadFile ----------------------------------------------------------

test_that("print.uploadFile shows object key and size", {
  r <- make_resp("uploadFile", list(objectKey = "aerial.dwg", size = 1024L))
  expect_output(print(r), "uploadFile")
  expect_output(print(r), "aerial.dwg")
  expect_output(print(r), "1024")
})

# print.uploadFileSigned ----------------------------------------------------

test_that("print.uploadFileSigned shows object key", {
  r <- make_resp("uploadFileSigned", list(objectKey = "big.rvt", size = 512000L))
  expect_output(print(r), "uploadFileSigned")
  expect_output(print(r), "big.rvt")
})

# print.listObjects ---------------------------------------------------------

test_that("print.listObjects shows count and object key", {
  r <- make_resp("listObjects", list(items = list(list(objectKey = "aerial.dwg"))))
  expect_output(print(r), "listObjects")
  expect_output(print(r), "1")
  expect_output(print(r), "aerial.dwg")
})

# print.deleteObject --------------------------------------------------------

test_that("print.deleteObject shows status", {
  r <- make_resp("deleteObject", list(status = 200L))
  expect_output(print(r), "deleteObject")
  expect_output(print(r), "200")
})

# print.makePdf -------------------------------------------------------------

test_that("print.makePdf shows WorkItem id and status", {
  r <- make_resp("makePdf", list(id = "wi-001", status = "pending"))
  expect_output(print(r), "makePdf")
  expect_output(print(r), "wi-001")
  expect_output(print(r), "pending")
})

# print.checkPdf ------------------------------------------------------------

test_that("print.checkPdf shows WorkItem id and status", {
  r <- make_resp("checkPdf", list(id = "wi-001", status = "success"))
  expect_output(print(r), "checkPdf")
  expect_output(print(r), "success")
})

# print.translateSvf --------------------------------------------------------

test_that("print.translateSvf shows result and urn", {
  r <- make_resp("translateSvf", list(result = "created", urn = "abc"))
  expect_output(print(r), "translateSvf")
  expect_output(print(r), "created")
})

# print.translateSvf2 -------------------------------------------------------

test_that("print.translateSvf2 shows result and urn", {
  r <- make_resp("translateSvf2", list(result = "created", urn = "abc"))
  expect_output(print(r), "translateSvf2")
  expect_output(print(r), "created")
})

# print.translateObj --------------------------------------------------------

test_that("print.translateObj shows result", {
  r <- make_resp("translateObj", list(result = "created", urn = "abc"))
  expect_output(print(r), "translateObj")
  expect_output(print(r), "created")
})

# print.translateStl --------------------------------------------------------

test_that("print.translateStl shows result", {
  r <- make_resp("translateStl", list(result = "created", urn = "abc"))
  expect_output(print(r), "translateStl")
  expect_output(print(r), "created")
})

# print.checkFile -----------------------------------------------------------

test_that("print.checkFile shows status and progress", {
  r <- make_resp("checkFile", list(status = "success", progress = "complete"))
  expect_output(print(r), "checkFile")
  expect_output(print(r), "success")
  expect_output(print(r), "complete")
})

# print.getMetadata ---------------------------------------------------------

test_that("print.getMetadata shows viewable count and name", {
  r <- make_resp("getMetadata", list(
    data = list(metadata = list(list(name = "aerial", guid = "g1")))
  ))
  expect_output(print(r), "getMetadata")
  expect_output(print(r), "1")
  expect_output(print(r), "aerial")
})

# print.getData -------------------------------------------------------------

test_that("print.getData shows property count", {
  r <- make_resp("getData", list(
    data = list(collection = list(list(name = "a"), list(name = "b")))
  ))
  expect_output(print(r), "getData")
  expect_output(print(r), "2")
})

# print.getObjectTree -------------------------------------------------------

test_that("print.getObjectTree shows object count", {
  r <- make_resp("getObjectTree", list(
    data = list(objects = list(list(objectCount = 42)))
  ))
  expect_output(print(r), "getObjectTree")
  expect_output(print(r), "42")
})

# print.getOutputUrn --------------------------------------------------------

test_that("print.getOutputUrn shows status and progress", {
  r <- make_resp("getOutputUrn", list(status = "success", progress = "complete"))
  expect_output(print(r), "getOutputUrn")
  expect_output(print(r), "success")
})

# print.downloadFile --------------------------------------------------------

test_that("print.downloadFile shows saved path", {
  r <- make_resp("downloadFile", list(destfile = "aerial.obj"))
  expect_output(print(r), "downloadFile")
  expect_output(print(r), "aerial.obj")
})

test_that("print.downloadFile shows JSON label when no destfile", {
  r <- make_resp("downloadFile", list(foo = "bar"))
  expect_output(print(r), "JSON")
})

# print.createPhotoscene ----------------------------------------------------

test_that("print.createPhotoscene shows photoscene id", {
  r <- make_resp("createPhotoscene",
    list(photoscene = list(photosceneid = "PS-001")))
  expect_output(print(r), "createPhotoscene")
  expect_output(print(r), "PS-001")
})

# print.uploadImages --------------------------------------------------------

test_that("print.uploadImages prints without error", {
  r <- make_resp("uploadImages", list(Files = list(file = list(filesize = "1024"))))
  expect_output(print(r), "uploadImages")
})

# print.processPhotoscene ---------------------------------------------------

test_that("print.processPhotoscene shows photoscene id", {
  r <- make_resp("processPhotoscene",
    list(photoscene = list(photosceneid = "PS-001")))
  expect_output(print(r), "processPhotoscene")
  expect_output(print(r), "PS-001")
})

# print.checkPhotoscene -----------------------------------------------------

test_that("print.checkPhotoscene shows progress", {
  r <- make_resp("checkPhotoscene",
    list(photoscene = list(progress = "75")))
  expect_output(print(r), "checkPhotoscene")
  expect_output(print(r), "75")
})
