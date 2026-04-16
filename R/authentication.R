#' Get a 2-Legged Token for Authentication.
#'
#' Get a 2-legged token for OAuth-based authentication to the AutoDesk
#' Platform Services (APS).
#' @param id A string. Client ID for the app generated from the AutoDesk Dev
#'   Portal.
#' @param secret A string. Client Secret for the app generated from the AutoDesk
#'   Dev Portal.
#' @param scope A string. Space-separated list of required scopes. May be
#'   \code{user-profile:read}, \code{data:read}, \code{data:write},
#'   \code{data:create}, \code{data:search}, \code{bucket:create},
#'   \code{bucket:read}, \code{bucket:update}, \code{bucket:delete},
#'   \code{code:all}, \code{account:read}, \code{account:write}, or a
#'   combination of these.
#' @return An object containing the \code{access_token}, \code{token_type}, and
#'   \code{expires_in} seconds.
#' @examples
#' \dontrun{
#' # Get a 2-legged token with the "data:read" and "data:write" scopes
#' resp <- getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"),
#'            scope = "data:write data:read")
#' myToken <- resp$content$access_token
#' }
#' @import httr2
#' @import jsonlite
#' @export
getToken <- function(id = NULL, secret = NULL, scope = "data:write data:read") {
  if (is.null(id)) stop("id is null")
  if (is.null(secret)) stop("secret is null")
  if (is.null(scope)) stop("scope is null")

  url <- 'https://developer.api.autodesk.com/authentication/v2/token'

  resp <- request(url) |>
    req_user_agent("https://github.com/paulgovan/AutoDeskR") |>
    req_timeout(60) |>
    req_body_form(
      client_id     = id,
      client_secret = secret,
      grant_type    = "client_credentials",
      scope         = scope
    ) |>
    req_perform()

  parsed <- resp_body_json(resp, simplifyVector = FALSE)

  structure(
    list(
      content  = parsed,
      path     = url,
      response = resp
    ),
    class = "getToken"
  )
}
