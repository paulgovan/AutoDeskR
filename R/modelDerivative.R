#' Translate a File into SVF Format.
#'
#' Translate an uploaded file into SVF format using the Model Derivative API.
#' @param urn A string. Source URN (objectId) for the file. Note the URN must be
#'   Base64 encoded. To encode the URN, see, for example, the
#'   \code{jsonlite::base64_enc} function.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{data:read} and \code{data:write} scopes.
#' @return An object containing the \code{result}, \code{urn}, and additional
#'   activity information.
#' @examples
#' \dontrun{
#' # Translate the "aerial.dwg" file into a svf file
#' myEncodedUrn <- jsonlite::base64_enc(myUrn)
#' resp <- translateSvf(urn = myEncodedUrn, token = myToken)
#' }
#' @import httr
#' @import jsonlite
#' @export
translateSvf <- function(urn = NULL, token = NULL) {
  if (is.null(urn)) stop("urn is null")
  if (is.null(token)) stop("token is null")
  url <- 'https://developer.api.autodesk.com/modelderivative/v2/designdata/job'
  dat <- list(
    input = list(
      urn = urn
    ),
    output = list(
      formats = list(
        structure(
          list(
            type = "svf",
            views =
              list(
                "2d",
                "3d"
              )
          )
        )
      )
    )
  )
  resp <- POST(url, add_headers(Authorization = paste0("Bearer ", token)),
               body = dat, encode = "json")

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
    class = "translateSvf"
  )

}

#' Check the Status of a Translated File.
#'
#' Check the status of a recently translated file using the Model Derivative API.
#' @param urn A string. Source URN (objectId) for the file. Note the URN must be
#'   Base64 encoded. To encode the URN, see, for example, the
#'   \code{jsonlite::base64_enc} function.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{data:read} and \code{data:write} scopes.
#' @examples
#' \dontrun{
#' # Check the status of the translated "aerial.dwg" svf file
#' resp <- checkFile(urn = myEncodedUrn, token = myToken)
#' resp
#' }
#' @import httr
#' @import jsonlite
#' @export
checkFile <- function(urn = NULL, token = NULL) {
  if (is.null(urn)) stop("urn is null")
  if (is.null(token)) stop("token is null")

  url <- paste0('https://developer.api.autodesk.com/modelderivative/v2/designdata/',
                urn, '/manifest')
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
    class = "checkFile"
  )

}

#' Get the Metadata for a File.
#'
#' Get the metadata of an uploaded file using the Model Derivative API.
#' @param urn A string. Source URN (objectId) for the file. Note the URN must be
#'   Base64 encoded. To encode the URN, see, for example, the
#'   \code{jsonlite::base64_enc} function.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{data:read} and \code{data:write} scopes.
#' @return An object containing the \code{type}, \code{name}, and \code{guid} of
#'   the file.
#' @examples
#' \dontrun{
#' # Get the metadata for the "aerial.dwg" svf file
#' resp <- getMetadata(urn <- myEncodedUrn, token = myToken)
#' myGuid <- resp$content$data$metadata[[1]]$guid
#' }
#' @import httr
#' @import jsonlite
#' @export
getMetadata <- function(urn = NULL, token = NULL) {
  if (is.null(urn)) stop("urn is null")
  if (is.null(token)) stop("token is null")

  url <- paste0('https://developer.api.autodesk.com/modelderivative/v2/designdata/', urn, '/metadata')
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
    class = "getMetadata"
  )

}

#' Get the Geometry Data for a File.
#'
#' Get the geometry of an uploaded file using the Model Derivative API.
#' @param guid A string. GUID retrieved via the \code{\link{getMetadata}}
#'   function.
#' @param urn A string. Source URN (objectId) for the file. Note the URN must be
#'   Base64 encoded. To encode the URN, see, for example, the
#'   \code{jsonlite::base64_enc} function.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{data:read} and \code{data:write} scopes.
#' @return An object containing the geometry data for the selected file.
#' @examples
#' \dontrun{
#' # Get the geometry data for the "aerial.dwg" svf file
#' resp <- getData(guid <- myGuid, urn <- myEncodedUrn, token = myToken)
#' }
#' @import httr
#' @import jsonlite
#' @export
getData <- function(guid = NULL, urn = NULL, token = NULL) {
  if (is.null(guid)) stop("guid is null")
  if (is.null(urn)) stop("urn is null")
  if (is.null(token)) stop("token is null")

  url <- paste0('https://developer.api.autodesk.com/modelderivative/v2/designdata/', urn, '/metadata/', guid, '/properties')

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
    class = "getData"
  )

}

#' Get the Object Tree of a File.
#'
#' Get the object tree of an uploaded file using the Model Derivative API.
#' @param guid A string. GUID retrieved via the \code{\link{getMetadata}}
#'   function.
#' @param urn A string. Source URN (objectId) for the file. Note the URN must be
#'   Base64 encoded. To encode the URN, see, for example, the
#'   \code{jsonlite::base64_enc} function.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{data:read} and \code{data:write} scopes.
#' @return An object containing the object tree for the selected file. the file.
#' @examples
#' \dontrun{
#' # Get the object tree for the "aerial.dwg" svf file
#' resp <- getObjectTree(guid <- myGuid, urn <- myEncodedUrn, token = myToken)
#' resp
#' }
#' @import httr
#' @import jsonlite
#' @export
getObjectTree <- function(guid = NULL, urn = NULL, token = NULL){
  if (is.null(guid)) stop("guid is null")
  if (is.null(urn)) stop("urn is null")
  if (is.null(token)) stop("token is null")
  url <- paste0('https://developer.api.autodesk.com/modelderivative/v2/designdata/', urn, '/metadata/', guid)

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
    class = "getObjectTree"
  )

}

#' Translate a File into OBJ Format.
#'
#' Translate an uploaded file into OBJ format using the Model Derivative API.
#' @param urn A string. Source URN (objectId) for the file. Note the URN must be
#'   Base64 encoded. To encode the URN, see, for example, the
#'   \code{jsonlite::base64_enc} function.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{data:read} and \code{data:write} scopes.
#' @return An object containing the \code{result}, \code{urn}, and additional
#'   activity information.
#' @examples
#' \dontrun{
#' # Translate the "aerial.dwg" file into a obj file
#' resp <- translateObj(urn <- myEncodedUrn, token = myToken)
#' }
#' @import httr
#' @import jsonlite
#' @export
translateObj <- function(urn = NULL, token = NULL) {
  if (is.null(urn)) stop("urn is null")
  if (is.null(token)) stop("token is null")

  url <- 'https://developer.api.autodesk.com/modelderivative/v2/designdata/job'
  dat <- list(
    input = list(
      urn = urn
    ),
    output = list(
      formats = list(
        structure(
          list(
            type = "obj"
          )
        )
      )
    )
  )
  resp <- POST(url, add_headers(Authorization = paste0("Bearer ", token)),
               body = dat, encode = "json")

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
    class = "translateObj"
  )

}

#' Get the Output URN for a File.
#'
#' Get the output urn of a translated file using the Model Derivative API.
#' @param urn A string. Source URN (objectId) for the file. Note the URN must be
#'   Base64 encoded. To encode the URN, see, for example, the
#'   \code{jsonlite::base64_enc} function.
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{data:read} and \code{data:write} scopes.
#' @return An object containing the \code{result}, \code{urn}, and additional
#'   activity information.
#' @examples
#' \dontrun{
#' # Get the output urn for the "aerial.dwg" obj file
#' resp <- getOutputUrn(urn <- myUrn, token = Sys.getenv("token"))
#' resp
#' }
#' @import httr
#' @import jsonlite
#' @export
getOutputUrn <- function(urn, token) {
  if (is.null(urn)) stop("urn is null")
  if (is.null(token)) stop("token is null")

  url <- paste0('https://developer.api.autodesk.com/modelderivative/v2/designdata/',
                urn, '/manifest')
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
    class = "getOutputUrn"
  )

}

#' Download a file locally.
#'
#' Download a file from the Forge Platform using the Model Derivative API.
#' @param urn A string. Source URN (objectId) for the file. Note the URN must be
#'   Base64 encoded. To encode the URN, see, for example, the
#'   \code{jsonlite::base64_enc} function.
#' @param output_urn A string. Output_urn retrieved via
#'   \code{\link{getOutputUrn}}
#' @param token A string. Token generated with \code{\link{getToken}} function
#'   with \code{data:read} and \code{data:write} scopes.
#' @return An object containing the \code{result}, \code{urn}, and additional
#'   activity information.
#' @examples
#' \dontrun{
#' # Download the "aerial.dwg" png file
#' myEncodedOutputUrn <- jsonlite::base64_enc(myOutputUrn)
#' resp <- downloadFile(urn <- myEncodedUrn, output_urn <- myEncodedOutputUrn, token = myToken)
#' }
#' @import httr
#' @import jsonlite
#' @export
downloadFile <- function(urn = NULL, output_urn = NULL, token = NULL) {
  if (is.null(urn)) stop("urn is null")
  if (is.null(output_urn)) stop("output_urn is null")
  if (is.null(token)) stop("token is null")

  url <- paste0('https://developer.api.autodesk.com/modelderivative/v2/designdata/', urn, '/manifest/', output_urn)

  resp <- GET(url, add_headers(Authorization = paste0("Bearer ", token)))

  warn_for_status(resp)

  parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)

  structure(
    list(
      content = parsed,
      path = url,
      response = resp
    ),
    class = "downloadFile"
  )

}
