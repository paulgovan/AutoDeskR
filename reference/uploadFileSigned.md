# Upload a File Using Signed S3 URLs.

Upload a design file of any size to an app-managed bucket using the
signed S3 URL approach recommended by AutoDesk Platform Services (APS).
Unlike
[`uploadFile`](https://paulgovan.github.io/AutoDeskR/reference/uploadFile.md),
this function supports files larger than 100 MB.

## Usage

``` r
uploadFileSigned(file = NULL, token = NULL, bucket = "mybucket")
```

## Arguments

- file:

  A string. File path.

- token:

  A string or `aps_token` object with `data:write` scope.

- bucket:

  A string. Unique bucket name. Defaults to `mybucket`.

## Value

An object containing the finalized upload response with `bucketKey`,
`objectId`, `objectKey`, `size`, and `location`.

## Examples

``` r
if (FALSE) { # \dontrun{
# Upload a large file using signed S3 URLs
resp <- uploadFileSigned(
  file   = "path/to/large_model.rvt",
  token  = myToken,
  bucket = "mybucket"
)
myUrn <- resp$content$objectId
} # }
```
