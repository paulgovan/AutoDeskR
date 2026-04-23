# Get a 2-Legged Token for Authentication.

Get a 2-legged token for OAuth-based authentication to the AutoDesk
Platform Services (APS).

## Usage

``` r
getToken(id = NULL, secret = NULL, scope = "data:write data:read")
```

## Arguments

- id:

  A string. Client ID for the app generated from the AutoDesk Dev
  Portal.

- secret:

  A string. Client Secret for the app generated from the AutoDesk Dev
  Portal.

- scope:

  A string. Space-separated list of required scopes. May be
  `user-profile:read`, `data:read`, `data:write`, `data:create`,
  `data:search`, `bucket:create`, `bucket:read`, `bucket:update`,
  `bucket:delete`, `code:all`, `account:read`, `account:write`, or a
  combination of these.

## Value

An `aps_token` object containing the `access_token`, `token_type`,
`expires_in`, and `expires_at`. The token can be passed directly to
other AutoDeskR functions. Use
[`is_expired`](http://paulgovan.github.io/AutoDeskR/reference/is_expired.md)
to check whether the token needs refreshing. Legacy access via
`resp$content$access_token` continues to work.

## Examples

``` r
if (FALSE) { # \dontrun{
tok <- getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"),
         scope = "data:write data:read")
myToken <- tok$access_token
is_expired(tok)
} # }
```
