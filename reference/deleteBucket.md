# Delete an App-Managed Bucket.

Delete an app-managed bucket using the Data Management API.

## Usage

``` r
deleteBucket(token = NULL, bucket = "mybucket")
```

## Arguments

- token:

  A string or `aps_token` object with `bucket:delete` scope.

- bucket:

  A string. Name of the bucket to delete. Defaults to `mybucket`.

## Value

An object containing the HTTP status code of the response.

## Examples

``` r
if (FALSE) { # \dontrun{
# Delete a bucket named "mybucket"
resp <- deleteBucket(token = myToken, bucket = "mybucket")
} # }
```
