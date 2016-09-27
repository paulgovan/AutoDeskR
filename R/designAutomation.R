#' Convert a DWG to a PDF.
#'
#' Convert a publicly accessible DWG file to a publicly accessible PDF using the Design Automation API.
#' @param source A string. Publicly accessible web address of the input dwg
#'   file.
#' @param destination A string. Publicly accessible web address for the output
#'   pdf file.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{code:all} scope.
#' @seealso
#'   \url{https://developer.autodesk.com/en/docs/design-automation/v2/overview/}
#' @examples
#' \dontrun{
#' mySource <- "http://download.autodesk.com/us/samplefiles/acad/visualization_-_aerial.dwg"
#' myDestination <- "https://drive.google.com/folderview?id=0BygncDVHf60mTDZVNDltLThLNmM&usp=sharing"
#' makePdf(mySource, myDestination, token = Sys.getenv("access_token"))
#' }
#' @import httr
#' @import jsonlite
#' @export
makePdf <- function(source = NULL, destination = NULL, token = NULL) {
  if (is.null(source)) stop("source is null")
  if (is.null(destination)) stop("destination is null")
  if (is.null(token)) stop("token is null")

  url <- 'https://developer.api.autodesk.com/autocad.io/us-east/v2/WorkItems'
  dat <- list(
    "@odata.type" = "#ACES.Models.WorkItem",
    Arguments = list(
      InputArguments = list(
        structure(
          list(
            Resource = source,
            Name = "HostDwg",
            StorageProvider = "Generic"
          )
        )
      ),
      OutputArguments = list(
        structure(
          list(
            Name = "Result",
            StorageProvider = "Generic",
            HttpVerb = "POST",
            Resource = destination
          )
        )
      )
    ),
    ActivityId = "PlotToPDF",
    Id = ""
  )
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
    class = "makePdf"
  )

}

#' Check the status of a PDF.
#'
#' Check the status of a recently created PDF file using the Design Automation
#' API.
#' @param source A string. Publicly accessible web address of the input dwg
#'   file.
#' @param destination A string. Publicly accessible web address for the output
#'   pdf file.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{code:all} scope.
#' @seealso
#'   \url{https://developer.autodesk.com/en/docs/design-automation/v2/overview/}
#' @examples
#' \dontrun{
#' mySource <- "http://download.autodesk.com/us/samplefiles/acad/visualization_-_aerial.dwg"
#' myDestination <- "https://drive.google.com/folderview?id=0BygncDVHf60mTDZVNDltLThLNmM&usp=sharing"
#' checkPdf(mySource, myDestination, token = Sys.getenv("access_token"))
#' }
#' @import httr
#' @import jsonlite
#' @export
checkPdf <- function(source = NULL, destination = NULL, token = NULL) {
  if (is.null(source)) stop("source is null")
  if (is.null(destination)) stop("destination is null")
  if (is.null(token)) stop("token is null")

  url <- 'https://developer.api.autodesk.com/autocad.io/us-east/v2/WorkItems'
  dat <- list(
    "@odata.type" = "#ACES.Models.WorkItem",
    Arguments = list(
      InputArguments = list(
        structure(
          list(
            Resource = source,
            Name = "HostDwg",
            StorageProvider = "Generic"
          )
        )
      ),
      OutputArguments = list(
        structure(
          list(
            Name = "Result",
            StorageProvider = "Generic",
            HttpVerb = "POST",
            Resource = destination
          )
        )
      )
    ),
    ActivityId = "PlotToPDF",
    Id = ""
  )

  resp <- GET(url, add_headers(Authorization = paste0("Bearer ", token)), body = dat, encode = "json")
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
    class = "checkPdf"
  )

}
