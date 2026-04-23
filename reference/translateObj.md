# Translate a File into OBJ Format.

Translate an uploaded file into OBJ format using the Model Derivative
API.

## Usage

``` r
translateObj(urn = NULL, token = NULL)
```

## Arguments

- urn:

  A string. Source URN (objectId) for the file. Note the URN must be
  Base64 encoded. To encode the URN, see, for example, the
  [`jsonlite::base64_enc`](https://jeroen.r-universe.dev/jsonlite/reference/base64.html)
  function.

- token:

  A string or `aps_token` object with `data:read` and `data:write`
  scopes.

## Value

An object containing the `result`, `urn`, and additional activity
information.

## Examples

``` r
if (FALSE) { # \dontrun{
# Translate the "aerial.dwg" file into an obj file
resp <- translateObj(urn = myEncodedUrn, token = myToken)
} # }
```
