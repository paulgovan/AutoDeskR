# Check the Status of a PDF WorkItem.

Check the status of a Design Automation WorkItem using the Design
Automation API v3.

## Usage

``` r
checkPdf(id = NULL, token = NULL, source = NULL, destination = NULL)
```

## Arguments

- id:

  A string. WorkItem ID returned by
  [`makePdf`](http://paulgovan.github.io/AutoDeskR/reference/makePdf.md)
  in `resp$content$id`.

- token:

  A string. Token generated with
  [`getToken`](http://paulgovan.github.io/AutoDeskR/reference/getToken.md)
  function with `code:all` scope.

- source:

  Deprecated. Ignored with a warning.

- destination:

  Deprecated. Ignored with a warning.

## Value

An object containing the WorkItem `id`, `status`, and `stats`.

## Examples

``` r
if (FALSE) { # \dontrun{
mySource <- "http://download.autodesk.com/us/samplefiles/acad/visualization_-_aerial.dwg"
myDestination <- "https://example.com/output/aerial.pdf"
resp <- makePdf(mySource, myDestination, token = myToken)
myWorkItemId <- resp$content$id

# Poll for completion
resp <- checkPdf(id = myWorkItemId, token = myToken)
resp
} # }
```
