# UI Module Function.

UI Module Function.

## Usage

``` r
viewerUI(id, urn = NULL, token = NULL, viewerType = "header")
```

## Arguments

- id:

  A string. A namespace for the module.

- urn:

  A string. Source URN (objectId) for the file. Note the URN must be
  Base64 encoded. To encode the URN, see, for example, the
  [`jsonlite::base64_enc`](https://jeroen.r-universe.dev/jsonlite/reference/base64.html)
  function.

- token:

  A string. Token generated with
  [`getToken`](http://paulgovan.github.io/AutoDeskR/reference/getToken.md)
  function with `data:read` scope.

- viewerType:

  A string. The type of viewer to instantiate. Either "header" for the
  default viewer or "headless" for a viewer without toolbar or panels.

## Examples

``` r
if (FALSE) { # \dontrun{
ui <- function(request) {
 shiny::fluidPage(
   viewerUI("pg", myEncodedUrn, myToken)
 )
}
server <- function(input, output, session) {
}
shiny::shinyApp(ui, server)
} # }
```
