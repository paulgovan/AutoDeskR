#' Launch the Viewer.
#'
#' @param urn A string. Source URN (objectId) for the file. Note the URN must be
#'   Base64 encoded. To encode the URN, see, for example, the
#'   \code{jsonlite::base64_enc} function.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{data:read} scope.
#' @param viewerType A string. The type of viewer to instantiate. Either
#'   "header" for the default viewer, "headless" for a viewer without toolbar
#'   or panels, or "vr" to enter WebVR mode on a mobile device.
#' @examples
#' \dontrun{
#' # View the "aerial.dwg" file in the AutoDesk viewer
#' myEncodedUrn <- jsonlite::base64_enc(myUrn)
#' viewer3D(urn <- myEncodedUrn, token = myToken)
#' }
#' @importFrom shiny shinyApp htmlTemplate
#' @export
viewer3D <- function(urn = NULL, token = NULL, viewerType = "header") {

  if (is.null(urn)) stop("urn is null")
  if (is.null(token)) stop("token is null")
  if (is.null(viewerType)) stop("viewerType is null")

  # Paste strings to be passed to html
  documentID <- paste0("'urn:", urn, "'")
  accessToken <- paste0("'", token, "'")

  # Choose an html template
  if (viewerType == "header") {
    template <- "template.html"
  } else if (viewerType == "vr"){
    template <- "vr.html"
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
#' @examples
#' \dontrun{
#' ui <- function(request) {
#'  shiny::fluidPage(
#'    viewerUI("pg", myEncodedUrn, myToken)
#'  )
#' }
#' server <- function(input, output, session) {
#' }
#' shiny::shinyApp(ui, server)
#' }
#' @importFrom shiny htmlTemplate NS fluidPage shinyApp
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
  } else if (viewerType == "vr"){
    template <- "vr.html"
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
