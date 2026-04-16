# Check the Status of a Translated File.

Check the status of a recently translated file using the Model
Derivative API.

## Usage

``` r
checkFile(urn = NULL, token = NULL)
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

## Examples

``` r
if (FALSE) { # \dontrun{
# Check the status of the translated "aerial.dwg" svf file
resp <- checkFile(urn = myEncodedUrn, token = myToken)
resp
} # }
```
