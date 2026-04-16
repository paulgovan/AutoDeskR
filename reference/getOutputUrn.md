# Get the Output URN for a File.

Get the output urn of a translated file using the Model Derivative API.

## Usage

``` r
getOutputUrn(urn, token)
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

An object containing the `result`, `urn`, and additional activity
information.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get the output urn for the "aerial.dwg" obj file
resp <- getOutputUrn(urn = myUrn, token = Sys.getenv("token"))
resp
} # }
```
