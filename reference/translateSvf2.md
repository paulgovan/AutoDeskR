# Translate a File into SVF2 Format.

Translate an uploaded file into SVF2 format using the Model Derivative
API. SVF2 is the next-generation viewer format: approximately 30 SVF and
faster to load in the Autodesk Viewer. Use it in place of
[`translateSvf`](http://paulgovan.github.io/AutoDeskR/reference/translateSvf.md)
for new projects.

## Usage

``` r
translateSvf2(urn = NULL, token = NULL, views = c("2d", "3d"))
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

- views:

  A character vector. Views to generate. Defaults to `c("2d", "3d")`.

## Value

An object containing the `result`, `urn`, and additional activity
information.

## Examples

``` r
if (FALSE) { # \dontrun{
# Translate the "aerial.dwg" file into SVF2 format
myEncodedUrn <- jsonlite::base64_enc(myUrn)
resp <- translateSvf2(urn = myEncodedUrn, token = myToken)
} # }
```
