#' Make a Bucket for an App.
#'
#' Make an app-based bucket for storage of design files using the Data Management API.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{bucket:create}, \code{bucket:read}, and \code{data:write}
#'   scopes.
#' @param bucket A string. Unique bucket name. Defaults to \code{mybucket}.
#' @param policy A string. May be \code{transient}, \code{temporary}, or
#'   \code{persistent}.
#' @return An object containing the \code{bucketKey}, \code{bucketOwner}, and
#'   \code{createdDate}.
#' @examples
#' \dontrun{
#' # Make a transient bucket with the name "mybucket"
#' resp <- makeBucket(token = myToken, bucket = "mybucket", policy = "transient")
#' }
#' @import httr2
#' @import jsonlite
#' @export
makeBucket <- function(token = NULL, bucket = "mybucket", policy = "transient") {
  if (is.null(token)) stop("token is null")
  if (is.null(bucket)) stop("bucket is null")
  if (is.null(policy)) stop("policy is null")

  url <- 'https://developer.api.autodesk.com/oss/v2/buckets'

  resp <- request(url) |>
    req_user_agent("https://github.com/paulgovan/AutoDeskR") |>
    req_headers(Authorization = paste0("Bearer ", token)) |>
    req_body_json(list(bucketKey = bucket, policyKey = policy)) |>
    req_perform()

  parsed <- resp_body_json(resp, simplifyVector = FALSE)

  structure(
    list(
      content  = parsed,
      path     = url,
      response = resp
    ),
    class = "makeBucket"
  )
}

#' Check the Status of an App-Managed Bucket.
#'
#' Check the status of a recently created app-managed bucket using the Data Management API.
#' @param token A string. Token generated with \code{\link{getToken}} function with \code{bucket:create}, \code{bucket:read}, and \code{data:write} scopes.
#' @param bucket A string. Name of the bucket. Defaults to \code{mybucket}.
#' @return An object containing the \code{bucketKey}, \code{bucketOwner}, and
#'   \code{createdDate}.
#' @examples
#' \dontrun{
#' # Check the status of a bucket with the name "mybucket"
#' resp <- checkBucket(token = myToken, bucket = "mybucket")
#' resp
#' }
#' @import httr2
#' @import jsonlite
#' @export
checkBucket <- function(token = NULL, bucket = "mybucket") {
  if (is.null(token)) stop("token is null")
  if (is.null(bucket)) stop("bucket is null")

  url <- paste0('https://developer.api.autodesk.com/oss/v2/buckets/', bucket, '/details')

  resp <- request(url) |>
    req_user_agent("https://github.com/paulgovan/AutoDeskR") |>
    req_headers(Authorization = paste0("Bearer ", token)) |>
    req_perform()

  parsed <- resp_body_json(resp, simplifyVector = FALSE)

  structure(
    list(
      content  = parsed,
      path     = url,
      response = resp
    ),
    class = "checkBucket"
  )
}

#' List All App-Managed Buckets.
#'
#' List all app-managed buckets using the Data Management API.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{bucket:read} scope.
#' @param limit An integer. Maximum number of buckets to return. Defaults to
#'   \code{10}.
#' @param startAt A string. Bucket key to start the list from (for pagination).
#'   Defaults to \code{NULL}.
#' @param region A string. Region filter. May be \code{"US"} or \code{"EMEA"}.
#'   Defaults to \code{"US"}.
#' @return An object containing a list of bucket details.
#' @examples
#' \dontrun{
#' # List all buckets
#' resp <- listBuckets(token = myToken)
#' resp$content$items
#' }
#' @import httr2
#' @import jsonlite
#' @export
listBuckets <- function(token = NULL, limit = 10, startAt = NULL, region = "US") {
  if (is.null(token)) stop("token is null")

  url <- 'https://developer.api.autodesk.com/oss/v2/buckets'

  req <- request(url) |>
    req_user_agent("https://github.com/paulgovan/AutoDeskR") |>
    req_headers(Authorization = paste0("Bearer ", token)) |>
    req_url_query(limit = limit, region = region)

  if (!is.null(startAt))
    req <- req |> req_url_query(startAt = startAt)

  resp <- req |> req_perform()

  parsed <- resp_body_json(resp, simplifyVector = FALSE)

  structure(
    list(
      content  = parsed,
      path     = url,
      response = resp
    ),
    class = "listBuckets"
  )
}

#' Delete an App-Managed Bucket.
#'
#' Delete an app-managed bucket using the Data Management API.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{bucket:delete} scope.
#' @param bucket A string. Name of the bucket to delete. Defaults to
#'   \code{mybucket}.
#' @return An object containing the HTTP status code of the response.
#' @examples
#' \dontrun{
#' # Delete a bucket named "mybucket"
#' resp <- deleteBucket(token = myToken, bucket = "mybucket")
#' }
#' @import httr2
#' @import jsonlite
#' @export
deleteBucket <- function(token = NULL, bucket = "mybucket") {
  if (is.null(token)) stop("token is null")
  if (is.null(bucket)) stop("bucket is null")

  url <- paste0('https://developer.api.autodesk.com/oss/v2/buckets/', bucket)

  resp <- request(url) |>
    req_user_agent("https://github.com/paulgovan/AutoDeskR") |>
    req_headers(Authorization = paste0("Bearer ", token)) |>
    req_method("DELETE") |>
    req_perform()

  structure(
    list(
      content  = list(status = resp_status(resp)),
      path     = url,
      response = resp
    ),
    class = "deleteBucket"
  )
}

#' Upload a File to an App-Managed Bucket.
#'
#' Upload a design file to an app-managed bucket using the Data Management API.
#' @param file A string. File path.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{bucket:create}, \code{bucket:read}, and \code{data:write}
#'   scopes.
#' @param bucket A string. Unique bucket name. Defaults to \code{mybucket}.
#' @return An object containing the \code{bucketKey}, \code{objectId} (i.e.
#'   urn), \code{objectKey} (i.e. file name), \code{size}, \code{contentType}
#'   (i.e. "application/octet-stream"), \code{location}. and other content
#'   information.
#' @examples
#' \dontrun{
#' # Upload the "aerial.dwg" file to "mybucket"
#' resp <- uploadFile(file = system.file("inst/samples/aerial.dwg", package = "AutoDeskR"),
#'            token = myToken, bucket = "mybucket")
#' myUrn <- resp$content$objectId
#' }
#' @import httr2
#' @import jsonlite
#' @export
uploadFile <- function(file = NULL, token = NULL, bucket = "mybucket") {
  if (is.null(file)) stop("file is null")
  if (is.null(token)) stop("token is null")
  if (is.null(bucket)) stop("bucket is null")

  url <- paste0("https://developer.api.autodesk.com/oss/v2/buckets/", bucket, "/objects/", basename(file))

  file_raw <- readBin(file, "raw", n = file.info(file)$size)

  resp <- request(url) |>
    req_user_agent("https://github.com/paulgovan/AutoDeskR") |>
    req_headers(Authorization = paste0("Bearer ", token)) |>
    req_method("PUT") |>
    req_body_raw(file_raw, type = "application/octet-stream") |>
    req_perform()

  parsed <- resp_body_json(resp, simplifyVector = FALSE)

  structure(
    list(
      content  = parsed,
      path     = url,
      response = resp
    ),
    class = "uploadFile"
  )
}

#' List Objects in an App-Managed Bucket.
#'
#' List objects stored in an app-managed bucket using the Data Management API.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{data:read} scope.
#' @param bucket A string. Name of the bucket. Defaults to \code{mybucket}.
#' @param limit An integer. Maximum number of objects to return. Defaults to
#'   \code{10}.
#' @return An object containing a list of objects in the bucket.
#' @examples
#' \dontrun{
#' # List objects in "mybucket"
#' resp <- listObjects(token = myToken, bucket = "mybucket")
#' resp$content$items
#' }
#' @import httr2
#' @import jsonlite
#' @export
listObjects <- function(token = NULL, bucket = "mybucket", limit = 10) {
  if (is.null(token)) stop("token is null")
  if (is.null(bucket)) stop("bucket is null")

  url <- paste0('https://developer.api.autodesk.com/oss/v2/buckets/', bucket, '/objects')

  resp <- request(url) |>
    req_user_agent("https://github.com/paulgovan/AutoDeskR") |>
    req_headers(Authorization = paste0("Bearer ", token)) |>
    req_url_query(limit = limit) |>
    req_perform()

  parsed <- resp_body_json(resp, simplifyVector = FALSE)

  structure(
    list(
      content  = parsed,
      path     = url,
      response = resp
    ),
    class = "listObjects"
  )
}

#' Delete an Object from an App-Managed Bucket.
#'
#' Delete an object from an app-managed bucket using the Data Management API.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{data:write} scope.
#' @param bucket A string. Name of the bucket. Defaults to \code{mybucket}.
#' @param object A string. Key (name) of the object to delete.
#' @return An object containing the HTTP status code of the response.
#' @examples
#' \dontrun{
#' # Delete the "aerial.dwg" object from "mybucket"
#' resp <- deleteObject(token = myToken, bucket = "mybucket", object = "aerial.dwg")
#' }
#' @import httr2
#' @import jsonlite
#' @export
deleteObject <- function(token = NULL, bucket = "mybucket", object = NULL) {
  if (is.null(token)) stop("token is null")
  if (is.null(bucket)) stop("bucket is null")
  if (is.null(object)) stop("object is null")

  url <- paste0('https://developer.api.autodesk.com/oss/v2/buckets/', bucket, '/objects/', object)

  resp <- request(url) |>
    req_user_agent("https://github.com/paulgovan/AutoDeskR") |>
    req_headers(Authorization = paste0("Bearer ", token)) |>
    req_method("DELETE") |>
    req_perform()

  structure(
    list(
      content  = list(status = resp_status(resp)),
      path     = url,
      response = resp
    ),
    class = "deleteObject"
  )
}
