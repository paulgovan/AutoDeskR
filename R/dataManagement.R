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
#' @seealso \url{https://developer.autodesk.com/en/docs/data/v2/overview/}
#' @examples
#' \dontrun{
#' # Make a transient bucket with the name "mybucket"
#' resp <- makeBucket(token = myToken, bucket = "mybucket", policy = "transient")
#' }
#' @import httr
#' @import jsonlite
#' @export
makeBucket <- function(token = NULL, bucket = "mybucket", policy = "transient") {
  if (is.null(token)) stop("token is null")
  if (is.null(bucket)) stop("bucket is null")
  if (is.null(policy)) stop("policy is null")
  if (policy != "transient" || "temporary" || "persistent")
    stop("Please select a bucket policy of 'transient', 'temporary', or 'persistent'")

  url <- 'https://developer.api.autodesk.com/oss/v2/buckets'
  dat <- list(bucketKey = bucket, policyKey = policy)
  resp <- POST(url, add_headers(Authorization = paste0("Bearer ", token)), body = dat, encode = "json")

  if (http_type(resp) != "application/json") {
    stop("AutoDesk API did not return json", call. = FALSE)
  }

  warn_for_status(resp)

  parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)

  structure(
    list(
      content = parsed,
      path = url,
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
#' @seealso \url{https://developer.autodesk.com/en/docs/data/v2/overview/}
#' @examples
#' \dontrun{
#' # Check the status of a bucket with the name "mybucket"
#' resp <- checkBucket(token = myToken, bucket = "mybucket")
#' resp
#' }
#' @import httr
#' @import jsonlite
#' @export
checkBucket <- function(token = NULL, bucket = "mybucket") {
  if (is.null(token)) stop("token is null")
  if (is.null(bucket)) stop("bucket is null")

  url <- paste0('https://developer.api.autodesk.com/oss/v2/buckets/', bucket, '/details')
  resp <- GET(url, add_headers(Authorization = paste0("Bearer ", token)))

  if (http_type(resp) != "application/json") {
    stop("AutoDesk API did not return json", call. = FALSE)
  }

  warn_for_status(resp)

  parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)

  structure(
    list(
      content = parsed,
      path = url,
      response = resp
    ),
    class = "checkBucket"
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
#' @seealso \url{https://developer.autodesk.com/en/docs/data/v2/overview/}
#' @examples
#' \dontrun{
#' # Upload the "aerial.dwg" file to "mybucket"
#' resp <- uploadFile(file = system.file("inst/samples/aerial.dwg", package = "AutoDeskR"),
#'            token = myToken, bucket = "mybucket")
#' myUrn <- resp$content$objectId
#' }
#' @import httr
#' @import jsonlite
#' @export
uploadFile <- function(file = NULL, token = NULL, bucket = "mybucket") {
  if (is.null(file)) stop("file is null")
  if (is.null(token)) stop("token is null")
  if (is.null(bucket)) stop("bucket is null")

  url <- paste0("https://developer.api.autodesk.com/oss/v2/buckets/", bucket, "/objects/", basename(file))
  resp <- PUT(url, add_headers(Authorization = paste0("Bearer ", token)), body = upload_file(file))

  if (http_type(resp) != "application/json") {
    stop("AutoDesk API did not return json", call. = FALSE)
  }

  warn_for_status(resp)

  parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)

  structure(
    list(
      content = parsed,
      path = url,
      response = resp
    ),
    class = "uploadFile"
  )

}
