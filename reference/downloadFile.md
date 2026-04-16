# Download a file locally.

Download a file from the AutoDesk Platform Services using the Model
Derivative API.

## Usage

``` r
downloadFile(urn = NULL, output_urn = NULL, token = NULL, destfile = NULL)
```

## Arguments

- urn:

  A string. Source URN (objectId) for the file. Note the URN must be
  Base64 encoded. To encode the URN, see, for example, the
  [`jsonlite::base64_enc`](https://jeroen.r-universe.dev/jsonlite/reference/base64.html)
  function.

- output_urn:

  A string. Output URN retrieved via
  [`getOutputUrn`](http://paulgovan.github.io/AutoDeskR/reference/getOutputUrn.md).

- token:

  A string. Token generated with
  [`getToken`](http://paulgovan.github.io/AutoDeskR/reference/getToken.md)
  function with `data:read` and `data:write` scopes.

- destfile:

  A string. Local file path to save binary responses (e.g. downloaded
  geometry files). When `NULL` and the response is not JSON, a warning
  is issued and the raw bytes are returned.

## Value

An object containing either parsed JSON content or, for binary
responses, the path to the saved file.

## Examples

``` r
if (FALSE) { # \dontrun{
# Download the "aerial.dwg" obj file
myEncodedOutputUrn <- jsonlite::base64_enc(myOutputUrn)
resp <- downloadFile(urn <- myEncodedUrn, output_urn <- myEncodedOutputUrn,
           token = myToken, destfile = "aerial.obj")
} # }
```
