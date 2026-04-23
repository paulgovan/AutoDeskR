#' Create a Photoscene for Reality Capture.
#'
#' Create a new photoscene for photogrammetry processing using the Reality
#' Capture API. Upload images with \code{\link{uploadImages}}, then start
#' processing with \code{\link{processPhotoscene}}.
#' @param name A string. Name for the photoscene.
#' @param format A string. Output format. One of \code{"rcm"}, \code{"rcs"},
#'   \code{"obj"}, \code{"ortho"}, or \code{"report"}. Defaults to
#'   \code{"rcm"}.
#' @param token A string or \code{aps_token} object with
#'   \code{data:read} and \code{data:write} scopes.
#' @return An object of class \code{createPhotoscene} containing the
#'   \code{photosceneid} at \code{resp$content$photoscene$photosceneid}.
#' @examples
#' \dontrun{
#' ps <- createPhotoscene(name = "my-scene", format = "obj", token = myToken)
#' myPhotosceneId <- ps$content$photoscene$photosceneid
#' }
#' @import httr2
#' @import jsonlite
#' @export
createPhotoscene <- function(name = NULL, format = "rcm", token = NULL) {
  if (is.null(name)) stop("name is null")
  if (is.null(token)) stop("token is null")

  token <- .resolve_token(token)

  url <- 'https://developer.api.autodesk.com/photo-to-3d/v1/photoscene'

  resp <- aps_request(url, token) |>
    req_body_form(scenename = name, scenetype = format) |>
    aps_perform()

  parsed <- resp_body_json(resp, simplifyVector = FALSE)

  structure(
    list(
      content  = parsed,
      path     = url,
      response = resp
    ),
    class = "createPhotoscene"
  )
}

#' Upload Images to a Photoscene.
#'
#' Upload one or more image files to an existing photoscene for Reality Capture
#' processing.
#' @param photoscene_id A string. Photoscene ID returned by
#'   \code{\link{createPhotoscene}}.
#' @param files A character vector. Local file paths to image files (JPEG or
#'   PNG).
#' @param token A string or \code{aps_token} object with
#'   \code{data:read} and \code{data:write} scopes.
#' @return An object of class \code{uploadImages} containing the upload
#'   response.
#' @examples
#' \dontrun{
#' imgs <- uploadImages(
#'   photoscene_id = myPhotosceneId,
#'   files         = c("img1.jpg", "img2.jpg", "img3.jpg"),
#'   token         = myToken
#' )
#' }
#' @import httr2
#' @import jsonlite
#' @importFrom curl form_file
#' @export
uploadImages <- function(photoscene_id = NULL, files = NULL, token = NULL) {
  if (is.null(photoscene_id)) stop("photoscene_id is null")
  if (is.null(files)) stop("files is null")
  if (is.null(token)) stop("token is null")

  token <- .resolve_token(token)

  url <- paste0('https://developer.api.autodesk.com/photo-to-3d/v1/photoscene/', photoscene_id, '/files')

  file_parts        <- lapply(files, curl::form_file)
  names(file_parts) <- paste0("file[", seq_along(files) - 1L, "]")
  parts <- c(list(type = "image", photosceneid = photoscene_id), file_parts)

  req  <- aps_request(url, token, timeout = 600)
  req  <- do.call(req_body_multipart, c(list(req), parts))
  resp <- aps_perform(req)

  parsed <- resp_body_json(resp, simplifyVector = FALSE)

  structure(
    list(
      content  = parsed,
      path     = url,
      response = resp
    ),
    class = "uploadImages"
  )
}

#' Start Reality Capture Processing.
#'
#' Initiate photogrammetry processing for a photoscene that has had images
#' uploaded via \code{\link{uploadImages}}.
#' @param photoscene_id A string. Photoscene ID returned by
#'   \code{\link{createPhotoscene}}.
#' @param token A string or \code{aps_token} object with
#'   \code{data:read} and \code{data:write} scopes.
#' @return An object of class \code{processPhotoscene} containing the
#'   processing response.
#' @examples
#' \dontrun{
#' proc <- processPhotoscene(photoscene_id = myPhotosceneId, token = myToken)
#' }
#' @import httr2
#' @import jsonlite
#' @export
processPhotoscene <- function(photoscene_id = NULL, token = NULL) {
  if (is.null(photoscene_id)) stop("photoscene_id is null")
  if (is.null(token)) stop("token is null")

  token <- .resolve_token(token)

  url <- paste0('https://developer.api.autodesk.com/photo-to-3d/v1/photoscene/', photoscene_id)

  resp <- aps_request(url, token) |>
    req_body_form(photosceneid = photoscene_id) |>
    aps_perform()

  parsed <- resp_body_json(resp, simplifyVector = FALSE)

  structure(
    list(
      content  = parsed,
      path     = url,
      response = resp
    ),
    class = "processPhotoscene"
  )
}

#' Check Reality Capture Processing Progress.
#'
#' Poll the processing status of a photoscene. Use
#' \code{\link{waitForPhotoscene}} to block until processing completes.
#' @param photoscene_id A string. Photoscene ID returned by
#'   \code{\link{createPhotoscene}}.
#' @param token A string or \code{aps_token} object with
#'   \code{data:read} and \code{data:write} scopes.
#' @return An object of class \code{checkPhotoscene} containing
#'   \code{resp$content$photoscene$progress} (percentage string) and
#'   \code{resp$content$photoscene$progressmsg}.
#' @examples
#' \dontrun{
#' status <- checkPhotoscene(photoscene_id = myPhotosceneId, token = myToken)
#' status$content$photoscene$progress
#' }
#' @import httr2
#' @import jsonlite
#' @export
checkPhotoscene <- function(photoscene_id = NULL, token = NULL) {
  if (is.null(photoscene_id)) stop("photoscene_id is null")
  if (is.null(token)) stop("token is null")

  token <- .resolve_token(token)

  url <- paste0('https://developer.api.autodesk.com/photo-to-3d/v1/photoscene/', photoscene_id, '/progress')

  resp <- aps_request(url, token) |>
    aps_perform()

  parsed <- resp_body_json(resp, simplifyVector = FALSE)

  structure(
    list(
      content  = parsed,
      path     = url,
      response = resp
    ),
    class = "checkPhotoscene"
  )
}

#' Wait for Reality Capture Processing to Complete.
#'
#' Polls \code{\link{checkPhotoscene}} at a fixed interval until processing
#' reaches 100\% or an error occurs.
#' @param photoscene_id A string. Photoscene ID returned by
#'   \code{\link{createPhotoscene}}.
#' @param token A string or \code{aps_token} object.
#' @param interval Seconds between polls. Defaults to \code{30}.
#' @param timeout Maximum seconds to wait before aborting. Defaults to
#'   \code{1800} (30 minutes).
#' @param verbose If \code{TRUE} (default), prints a message after each poll.
#' @return The final \code{\link{checkPhotoscene}} response object.
#' @examples
#' \dontrun{
#' ps   <- createPhotoscene("my-scene", token = myToken)
#' id   <- ps$content$photoscene$photosceneid
#' imgs <- uploadImages(id, c("img1.jpg", "img2.jpg"), myToken)
#' proc <- processPhotoscene(id, myToken)
#' done <- waitForPhotoscene(id, myToken)
#' done$content$photoscene$progress
#' }
#' @export
waitForPhotoscene <- function(photoscene_id, token, interval = 30, timeout = 1800,
                               verbose = TRUE) {
  deadline <- Sys.time() + timeout
  repeat {
    resp     <- checkPhotoscene(photoscene_id = photoscene_id, token = token)
    progress <- resp$content$photoscene$progress %||% "0"
    msg      <- resp$content$photoscene$progressmsg %||% ""
    if (verbose) message("Reality Capture progress: ", progress, " - ", msg)
    if (identical(progress, "100")) return(resp)
    if (Sys.time() > deadline)
      stop("waitForPhotoscene() timed out after ", timeout, " seconds.")
    Sys.sleep(interval)
  }
}
