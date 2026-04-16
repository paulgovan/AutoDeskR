# Make a Bucket for an App.

Make an app-based bucket for storage of design files using the Data
Management API.

## Usage

``` r
makeBucket(token = NULL, bucket = "mybucket", policy = "transient")
```

## Arguments

- token:

  A string. Token generated with
  [`getToken`](http://paulgovan.github.io/AutoDeskR/reference/getToken.md)
  function with `bucket:create`, `bucket:read`, and `data:write` scopes.

- bucket:

  A string. Unique bucket name. Defaults to `mybucket`.

- policy:

  A string. May be `transient`, `temporary`, or `persistent`.

## Value

An object containing the `bucketKey`, `bucketOwner`, and `createdDate`.

## Examples

``` r
if (FALSE) { # \dontrun{
# Make a transient bucket with the name "mybucket"
resp <- makeBucket(token = myToken, bucket = "mybucket", policy = "transient")
} # }
```
