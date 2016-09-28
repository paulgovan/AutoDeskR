#' Launch the Viewer.
#'
#' @param urn A string. Source URN (objectId) for the file. Note the URN must be
#'   Base64 encoded. To encode the URN, see, for example, the
#'   \code{jsonlite::base64_enc} function.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{data:read} scope.
#' @param viewerType A string. The type of viewer to instantiate. Either
#'   "header" for the default viewer or "headless" for a viewer without toolbar
#'   or panels.
#' @seealso
#' \url{https://developer.autodesk.com/en/docs/viewer/v2/overview/}
#' @examples
#' \dontrun{
#' # View the "aerial.dwg" file in the AutoDesk viewer
#' myUrn <- jsonlite::base64_enc(Sys.getenv("urn"))
#' viewer3D(urn <- myUrn, token = Sys.getenv("access_token"))
#' }
#' @importFrom shiny shinyApp htmlTemplate
#' @export
viewer3D <- function(urn = NULL, token = NULL, viewerType = "header") {

  if (is.null(urn)) stop("urn is null")
  if (is.null(token)) stop("token is null")
  if (is.null(viewerType)) stop("viewerType is null")
  if (viewerType != "header" || "headless")
    stop("Please choose a viewerType of 'header' or 'headless'")

  # Paste strings to be passed to html
  documentID <- paste0("'urn:", urn, "'")
  accessToken <- paste0("'", token, "'")

  # Choose an html template
  if (viewerType == "header") {
    template <- "template.html"
  } else {
    template <- "headless.html"
  }

  # Run app
  shiny::shinyApp(
    ui = shiny::htmlTemplate(system.file("viewer3D", template, package = "AutoDeskR"),
                             documentID = documentID,
                             accessToken = accessToken
    ),
    server = function(input, output) {
    }
  )
}

#' UI Module Function.
#'
#' @param id A string. A namespace for the module.
#' @param urn A string. Source URN (objectId) for the file. Note the URN must be
#'   Base64 encoded. To encode the URN, see, for example, the
#'   \code{jsonlite::base64_enc} function.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{data:read} scope.
#' @param viewerType A string. The type of viewer to instantiate. Either
#'   "header" for the default viewer or "headless" for a viewer without toolbar
#'   or panels.
#' @seealso
#' \url{https://developer.autodesk.com/en/docs/viewer/v2/overview/}
#' @examples
#' \dontrun{
#' myUrn <- jsonlite::base64_enc(Sys.getenv("urn"))
#' ui <- function(request) {
#'  fluidPage(
#'    viewerUI("pg", myURN, Sys.getenv("access_token"))
#'  )
#' }
#' server <- function(input, output, session) {
#' }
#' shinyApp(ui, server)
#' }
#' @importFrom shiny htmlTemplate NS
#' @export
viewerUI <- function(id, urn = NULL, token = NULL, viewerType = "header") {

  if (is.null(urn)) stop("urn is null")
  if (is.null(token)) stop("token is null")
  if (viewerType != "header" || "headless")
    stop("Please choose a viewerType of 'header' or 'headless'")

  # Paste strings to be passed to html
  documentID <- paste0("'urn:", urn, "'")
  accessToken <- paste0("'", token, "'")

  # Choose an html template
  if (viewerType == "header") {
    template <- "template.html"
  } else {
    template <- "headless.html"
  }

  # Send the htmlTemplate to Shiny
  ns <- shiny::NS(id)
  shiny::htmlTemplate(system.file("viewer3D", template, package = "AutoDeskR"),
                      documentID = documentID,
                      accessToken = accessToken
  )
}
