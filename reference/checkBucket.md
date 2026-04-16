# Check the Status of an App-Managed Bucket.

Check the status of a recently created app-managed bucket using the Data
Management API.

## Usage

``` r
checkBucket(token = NULL, bucket = "mybucket")
```

## Arguments

- token:

  A string. Token generated with
  [`getToken`](http://paulgovan.github.io/AutoDeskR/reference/getToken.md)
  function with `bucket:create`, `bucket:read`, and `data:write` scopes.

- bucket:

  A string. Name of the bucket. Defaults to `mybucket`.

## Value

An object containing the `bucketKey`, `bucketOwner`, and `createdDate`.

## Examples

``` r
if (FALSE) { # \dontrun{
# Check the status of a bucket with the name "mybucket"
resp <- checkBucket(token = myToken, bucket = "mybucket")
resp
} # }
```
