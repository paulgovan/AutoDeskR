# Check Whether an aps_token Has Expired.

Check Whether an aps_token Has Expired.

## Usage

``` r
is_expired(token)
```

## Arguments

- token:

  An `aps_token` object returned by
  [`getToken`](https://paulgovan.github.io/AutoDeskR/reference/getToken.md).

## Value

Logical. `TRUE` if the token has expired, `FALSE` otherwise.

## Examples

``` r
if (FALSE) { # \dontrun{
tok <- getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"))
is_expired(tok)
} # }
```
