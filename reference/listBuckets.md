# List All App-Managed Buckets.

List all app-managed buckets using the Data Management API.

## Usage

``` r
listBuckets(token = NULL, limit = 10, startAt = NULL, region = "US")
```

## Arguments

- token:

  A string. Token generated with
  [`getToken`](http://paulgovan.github.io/AutoDeskR/reference/getToken.md)
  function with `bucket:read` scope.

- limit:

  An integer. Maximum number of buckets to return. Defaults to `10`.

- startAt:

  A string. Bucket key to start the list from (for pagination). Defaults
  to `NULL`.

- region:

  A string. Region filter. May be `"US"` or `"EMEA"`. Defaults to
  `"US"`.

## Value

An object containing a list of bucket details.

## Examples

``` r
if (FALSE) { # \dontrun{
# List all buckets
resp <- listBuckets(token = myToken)
resp$content$items
} # }
```
