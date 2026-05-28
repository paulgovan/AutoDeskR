# Launch the Viewer.

Launch the Viewer.

## Usage

``` r
viewer3D(urn = NULL, token = NULL, viewerType = "header")
```

## Arguments

- urn:

  A string. Source URN (objectId) for the file. Note the URN must be
  Base64 encoded. To encode the URN, see, for example, the
  [`jsonlite::base64_enc`](https://jeroen.r-universe.dev/jsonlite/reference/base64.html)
  function.

- token:

  A string. Token generated with
  [`getToken`](https://paulgovan.github.io/AutoDeskR/reference/getToken.md)
  function with `data:read` scope.

- viewerType:

  A string. The type of viewer to instantiate. Either "header" for the
  default viewer, "headless" for a viewer without toolbar or panels, or
  "vr" to enter WebVR mode on a mobile device.

## Examples

``` r
if (FALSE) { # \dontrun{
# View the "aerial.dwg" file in the AutoDesk viewer
myEncodedUrn <- jsonlite::base64_enc(myUrn)
viewer3D(urn <- myEncodedUrn, token = myToken)
} # }
```
