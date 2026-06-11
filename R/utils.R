#' Create an APS API Error Condition.
#'
#' Create a structured error condition for failures returned by the AutoDesk
#' Platform Services (APS) API. Callers can use
#' \code{tryCatch(..., aps_error = function(e) ...)} to handle these errors.
#' @param message A string. Human-readable error message.
#' @param status An integer. HTTP status code.
#' @param body A list. Parsed JSON body of the error response.
#' @param call The call where the error occurred (internal use).
#' @return A condition object of class \code{c("aps_error", "error", "condition")}.
#' @examples
#' \dontrun{
#' tryCatch(
#'   makeBucket(token = "bad_token"),
#'   aps_error = function(e) cat("HTTP", e$status, "-", e$message)
#' )
#' }
#' @export
aps_error <- function(message, status, body, call = sys.call(-1)) {
  structure(
    class = c("aps_error", "error", "condition"),
    list(message = message, status = status, body = body, call = call)
  )
}

# Internal: wrap httr2::req_perform() and decode APS JSON error bodies
aps_perform <- function(req) {
  tryCatch(
    req_perform(req),
    httr2_http = function(e) {
      body <- tryCatch(
        resp_body_json(e$resp, simplifyVector = FALSE),
        error = function(...) list()
      )
      msg <- body[["message"]] %||% body[["reason"]] %||% conditionMessage(e)
      stop(aps_error(
        message = paste0("APS API error (HTTP ", resp_status(e$resp), "): ", msg),
        status  = resp_status(e$resp),
        body    = body
      ))
    }
  )
}

# Internal: shared httr2 request builder
aps_request <- function(url, token = NULL, method = "GET", timeout = 60) {
  req <- request(url) |>
    req_user_agent("https://github.com/paulgovan/AutoDeskR") |>
    req_timeout(timeout)
  if (!is.null(token))
    req <- req |> req_headers(Authorization = paste0("Bearer ", token))
  if (method != "GET")
    req <- req |> req_method(method)
  req
}

# Internal: resolve an aps_token or plain string to a bearer token string
.resolve_token <- function(token) {
  if (inherits(token, "aps_token")) {
    if (is_expired(token))
      warning("Token may be expired. Consider calling getToken() again.", call. = FALSE)
    token$access_token
  } else {
    token
  }
}

# Internal: aps_token constructor — built from the parsed /authentication/v2/token response
new_aps_token <- function(parsed, url, raw_resp) {
  now <- Sys.time()
  structure(
    list(
      access_token = parsed$access_token,
      token_type   = parsed$token_type,
      expires_in   = parsed$expires_in,
      expires_at   = now + parsed$expires_in - 60L,
      fetched_at   = now,
      path         = url,
      response     = raw_resp
    ),
    class = c("aps_token", "getToken")
  )
}

#' Check Whether an aps_token Has Expired.
#'
#' @param token An \code{aps_token} object returned by \code{\link{getToken}}.
#' @return Logical. \code{TRUE} if the token has expired, \code{FALSE} otherwise.
#' @examples
#' \dontrun{
#' tok <- getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"))
#' is_expired(tok)
#' }
#' @export
is_expired <- function(token) UseMethod("is_expired")

#' @export
is_expired.aps_token <- function(token) {
  Sys.time() >= token$expires_at
}

#' @export
`$.aps_token` <- function(x, name) {
  if (name == "content") {
    list(
      access_token = .subset2(x, "access_token"),
      token_type   = .subset2(x, "token_type"),
      expires_in   = .subset2(x, "expires_in")
    )
  } else {
    .subset2(x, name)
  }
}

#' Wait for a Model Derivative Translation to Complete.
#'
#' Polls \code{\link{checkFile}} at a fixed interval until the translation
#' reaches a terminal state (\code{"success"}, \code{"failed"}, or
#' \code{"timeout"}).
#' @param urn A string. Base64-encoded source URN.
#' @param token A string or \code{aps_token} object with \code{data:read} scope.
#' @param interval Seconds between polls. Defaults to \code{5}.
#' @param timeout Maximum seconds to wait before aborting. Defaults to
#'   \code{300}.
#' @param verbose If \code{TRUE} (default), prints a message after each poll.
#' @return The final \code{\link{checkFile}} response object.
#' @examples
#' \dontrun{
#' myEncodedUrn <- jsonlite::base64_enc(myUrn)
#' resp <- translateSvf(urn = myEncodedUrn, token = myToken)
#' done <- waitForFile(urn = myEncodedUrn, token = myToken)
#' done$content$status
#' }
#' @export
waitForFile <- function(urn, token, interval = 5, timeout = 300, verbose = TRUE) {
  deadline <- Sys.time() + timeout
  repeat {
    resp <- tryCatch(
      checkFile(urn = urn, token = token),
      error = function(e) {
        if (verbose) message("Poll error (retrying): ", conditionMessage(e))
        NULL
      }
    )
    if (!is.null(resp)) {
      status <- resp$content$status
      if (verbose) message("Translation status: ", status)
      if (status %in% c("success", "failed", "timeout")) return(resp)
    }
    if (Sys.time() > deadline)
      stop("waitForFile() timed out after ", timeout, " seconds.")
    Sys.sleep(interval)
  }
}

#' Wait for a Design Automation WorkItem to Complete.
#'
#' Polls \code{\link{checkPdf}} at a fixed interval until the WorkItem reaches
#' a terminal state (any status other than \code{"inprogress"} or
#' \code{"pending"}).
#' @param id A string. WorkItem ID from \code{makePdf()$content$id}.
#' @param token A string or \code{aps_token} object with \code{code:all} scope.
#' @param interval Seconds between polls. Defaults to \code{5}.
#' @param timeout Maximum seconds to wait before aborting. Defaults to
#'   \code{300}.
#' @param verbose If \code{TRUE} (default), prints a message after each poll.
#' @return The final \code{\link{checkPdf}} response object.
#' @examples
#' \dontrun{
#' resp <- makePdf(source = mySource, destination = myDest, token = myToken)
#' done <- waitForWorkItem(id = resp$content$id, token = myToken)
#' done$content$status
#' }
#' @export
waitForWorkItem <- function(id, token, interval = 5, timeout = 300, verbose = TRUE) {
  deadline <- Sys.time() + timeout
  repeat {
    resp <- tryCatch(
      checkPdf(id = id, token = token),
      error = function(e) {
        if (verbose) message("Poll error (retrying): ", conditionMessage(e))
        NULL
      }
    )
    if (!is.null(resp)) {
      status <- resp$content$status
      if (verbose) message("WorkItem status: ", status)
      if (!identical(status, "inprogress") && !identical(status, "pending"))
        return(resp)
    }
    if (Sys.time() > deadline)
      stop("waitForWorkItem() timed out after ", timeout, " seconds.")
    Sys.sleep(interval)
  }
}

#' Convert a listBuckets Response to a Tibble.
#'
#' Requires the \code{tibble} package.
#' @param x A \code{listBuckets} response object.
#' @param ... Additional arguments (unused).
#' @return A \code{\link[tibble]{tibble}} with one row per bucket and columns
#'   \code{bucketKey}, \code{bucketOwner}, and \code{policyKey}.
#' @examples
#' \dontrun{
#' library(tibble)
#' listBuckets(token = myToken) |> as_tibble()
#' }
#' @exportS3Method tibble::as_tibble
as_tibble.listBuckets <- function(x, ...) {
  if (!requireNamespace("tibble", quietly = TRUE))
    stop("Package 'tibble' needed. Install with: install.packages('tibble')")
  items <- x$content$items %||% list()
  tibble::tibble(
    bucketKey   = vapply(items, `[[`, character(1), "bucketKey"),
    bucketOwner = vapply(items, `[[`, character(1), "bucketOwner"),
    policyKey   = vapply(items, `[[`, character(1), "policyKey")
  )
}

#' Convert a listObjects Response to a Tibble.
#'
#' Requires the \code{tibble} package.
#' @param x A \code{listObjects} response object.
#' @param ... Additional arguments (unused).
#' @return A \code{\link[tibble]{tibble}} with one row per object and columns
#'   \code{objectKey}, \code{objectId}, \code{size}, and \code{location}.
#' @examples
#' \dontrun{
#' library(tibble)
#' listObjects(token = myToken, bucket = "mybucket") |> as_tibble()
#' }
#' @exportS3Method tibble::as_tibble
as_tibble.listObjects <- function(x, ...) {
  if (!requireNamespace("tibble", quietly = TRUE))
    stop("Package 'tibble' needed. Install with: install.packages('tibble')")
  items <- x$content$items %||% list()
  tibble::tibble(
    objectKey = vapply(items, `[[`, character(1), "objectKey"),
    objectId  = vapply(items, `[[`, character(1), "objectId"),
    size      = vapply(items, function(i) as.integer(i[["size"]]), integer(1)),
    location  = vapply(items, `[[`, character(1), "location")
  )
}
