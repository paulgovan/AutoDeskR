#' Get a 2-Legged Token for Authentication.
#'
#' Get a 2-legged token for OAuth-based authentication to the AutoDesk Forge
#' Platform.
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
#' @return An object containing the \code{access_token}, \code{code_type}, and
#'   \code{expires_in} milliseconds.
#' @seealso \url{https://developer.autodesk.com/en/docs/oauth/v2/overview/}
#' @examples
#' \dontrun{
#' # Get a 2-legged token with the "data:read" and "data:write" scopes
#' resp <- getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"),
#'            scope = "data:write data:read")
#' myToken <- resp$content$access_token
#' }
#' @import httr
#' @import jsonlite
#' @export
getToken <- function(id = NULL, secret = NULL, scope = "data:write data:read") {
  if (is.null(id)) stop("id is null")
  if (is.null(secret)) stop("secret is null")
  if (is.null(scope)) stop("scope is null")

  url <- 'https://developer.api.autodesk.com/authentication/v1/authenticate'
  dat = list(client_id = id,
             client_secret = secret,
             grant_type = "client_credentials",
             scope = scope)
  resp <- POST(url, user_agent("https://github.com/paulgovan/AutoDeskR"),
               body = dat, encode = "form")

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
    class = "getToken"
  )

}
