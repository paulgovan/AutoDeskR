# Get the Geometry Data for a File.

Get the geometry of an uploaded file using the Model Derivative API.

## Usage

``` r
getData(guid = NULL, urn = NULL, token = NULL)
```

## Arguments

- guid:

  A string. GUID retrieved via the
  [`getMetadata`](https://paulgovan.github.io/AutoDeskR/reference/getMetadata.md)
  function.

- urn:

  A string. Source URN (objectId) for the file. Note the URN must be
  Base64 encoded. To encode the URN, see, for example, the
  [`jsonlite::base64_enc`](https://jeroen.r-universe.dev/jsonlite/reference/base64.html)
  function.

- token:

  A string or `aps_token` object with `data:read` and `data:write`
  scopes.

## Value

An object containing the geometry data for the selected file.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get the geometry data for the "aerial.dwg" svf file
resp <- getData(guid = myGuid, urn = myEncodedUrn, token = myToken)
} # }
```
