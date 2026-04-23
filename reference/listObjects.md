# List Objects in an App-Managed Bucket.

List objects stored in an app-managed bucket using the Data Management
API.

## Usage

``` r
listObjects(token = NULL, bucket = "mybucket", limit = 10)
```

## Arguments

- token:

  A string or `aps_token` object with `data:read` scope.

- bucket:

  A string. Name of the bucket. Defaults to `mybucket`.

- limit:

  An integer. Maximum number of objects to return. Defaults to `10`.

## Value

An object containing a list of objects in the bucket.

## Examples

``` r
if (FALSE) { # \dontrun{
# List objects in "mybucket"
resp <- listObjects(token = myToken, bucket = "mybucket")
resp$content$items
} # }
```
