# Get the Object Tree of a File.

Get the object tree of an uploaded file using the Model Derivative API.

## Usage

``` r
getObjectTree(guid = NULL, urn = NULL, token = NULL)
```

## Arguments

- guid:

  A string. GUID retrieved via the
  [`getMetadata`](http://paulgovan.github.io/AutoDeskR/reference/getMetadata.md)
  function.

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

An object containing the object tree for the selected file.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get the object tree for the "aerial.dwg" svf file
resp <- getObjectTree(guid <- myGuid, urn <- myEncodedUrn, token = myToken)
resp
} # }
```
