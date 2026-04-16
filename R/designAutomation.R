#' Convert a DWG to a PDF.
#'
#' Convert a publicly accessible DWG file to a publicly accessible PDF using the Design Automation API v3.
#' @param source A string. Publicly accessible web address of the input DWG
#'   file.
#' @param destination A string. Publicly accessible web address for the output
#'   PDF file.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{code:all} scope.
#' @return An object containing the WorkItem \code{id}, \code{status}, and
#'   \code{stats}. Use \code{id} with \code{\link{checkPdf}} to poll for
#'   completion.
#' @examples
#' \dontrun{
#' mySource <- "http://download.autodesk.com/us/samplefiles/acad/visualization_-_aerial.dwg"
#' myDestination <- "https://example.com/output/aerial.pdf"
#' resp <- makePdf(mySource, myDestination, token = myToken)
#' myWorkItemId <- resp$content$id
#' }
#' @import httr2
#' @import jsonlite
#' @export
makePdf <- function(source = NULL, destination = NULL, token = NULL) {
  if (is.null(source)) stop("source is null")
  if (is.null(destination)) stop("destination is null")
  if (is.null(token)) stop("token is null")

  url <- 'https://developer.api.autodesk.com/da/us-east/v3/workitems'
  dat <- list(
    activityId = "Autodesk.PlotToPDF+prod",
    arguments  = list(
      HostDwg = list(url = source,      verb = "get"),
      Result  = list(url = destination, verb = "put")
    )
  )

  resp <- request(url) |>
    req_user_agent("https://github.com/paulgovan/AutoDeskR") |>
    req_timeout(60) |>
    req_headers(Authorization = paste0("Bearer ", token)) |>
    req_body_json(dat) |>
    req_perform()

  parsed <- resp_body_json(resp, simplifyVector = FALSE)

  structure(
    list(
      content  = parsed,
      path     = url,
      response = resp
    ),
    class = "makePdf"
  )
}

#' Check the Status of a PDF WorkItem.
#'
#' Check the status of a Design Automation WorkItem using the Design Automation
#' API v3.
#' @param id A string. WorkItem ID returned by \code{\link{makePdf}} in
#'   \code{resp$content$id}.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{code:all} scope.
#' @param source Deprecated. Ignored with a warning.
#' @param destination Deprecated. Ignored with a warning.
#' @return An object containing the WorkItem \code{id}, \code{status}, and
#'   \code{stats}.
#' @examples
#' \dontrun{
#' mySource <- "http://download.autodesk.com/us/samplefiles/acad/visualization_-_aerial.dwg"
#' myDestination <- "https://example.com/output/aerial.pdf"
#' resp <- makePdf(mySource, myDestination, token = myToken)
#' myWorkItemId <- resp$content$id
#'
#' # Poll for completion
#' resp <- checkPdf(id = myWorkItemId, token = myToken)
#' resp
#' }
#' @import httr2
#' @import jsonlite
#' @export
checkPdf <- function(id = NULL, token = NULL, source = NULL, destination = NULL) {
  if (!is.null(source) || !is.null(destination))
    warning("'source' and 'destination' are deprecated in checkPdf(); use 'id' instead.")
  if (is.null(id)) stop("id is null")
  if (is.null(token)) stop("token is null")

  url <- paste0('https://developer.api.autodesk.com/da/us-east/v3/workitems/', id)

  resp <- request(url) |>
    req_user_agent("https://github.com/paulgovan/AutoDeskR") |>
    req_timeout(60) |>
    req_headers(Authorization = paste0("Bearer ", token)) |>
    req_perform()

  parsed <- resp_body_json(resp, simplifyVector = FALSE)

  structure(
    list(
      content  = parsed,
      path     = url,
      response = resp
    ),
    class = "checkPdf"
  )
}
