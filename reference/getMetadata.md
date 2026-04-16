# Get the Metadata for a File.

Get the metadata of an uploaded file using the Model Derivative API.

## Usage

``` r
getMetadata(urn = NULL, token = NULL)
```

## Arguments

- urn:

  A string. Source URN (objectId) for the file. Note the URN must be
  Base64 encoded. To encode the URN, see, for example, the
  [`jsonlite::base64_enc`](https://jeroen.r-universe.dev/jsonlite/reference/base64.html)
  function.

- token:

  A string. Token generated with
  [`getToken`](http://paulgovan.github.io/AutoDeskR/reference/getToken.md)
  function with `data:read` and `data:write` scopes.

## Value

An object containing the `type`, `name`, and `guid` of the file.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get the metadata for the "aerial.dwg" svf file
resp <- getMetadata(urn <- myEncodedUrn, token = myToken)
myGuid <- resp$content$data$metadata[[1]]$guid
} # }
```
