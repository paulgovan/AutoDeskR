# Upload a File to an App-Managed Bucket.

Upload a design file to an app-managed bucket using the Data Management
API.

## Usage

``` r
uploadFile(file = NULL, token = NULL, bucket = "mybucket")
```

## Arguments

- file:

  A string. File path.

- token:

  A string. Token generated with
  [`getToken`](http://paulgovan.github.io/AutoDeskR/reference/getToken.md)
  function with `bucket:create`, `bucket:read`, and `data:write` scopes.

- bucket:

  A string. Unique bucket name. Defaults to `mybucket`.

## Value

An object containing the `bucketKey`, `objectId` (i.e. urn), `objectKey`
(i.e. file name), `size`, `contentType` (i.e.
"application/octet-stream"), `location`. and other content information.

## Examples

``` r
if (FALSE) { # \dontrun{
# Upload the "aerial.dwg" file to "mybucket"
resp <- uploadFile(file = system.file("inst/samples/aerial.dwg", package = "AutoDeskR"),
           token = myToken, bucket = "mybucket")
myUrn <- resp$content$objectId
} # }
```
