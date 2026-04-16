# Convert a DWG to a PDF.

Convert a publicly accessible DWG file to a publicly accessible PDF
using the Design Automation API v3.

## Usage

``` r
makePdf(source = NULL, destination = NULL, token = NULL)
```

## Arguments

- source:

  A string. Publicly accessible web address of the input DWG file.

- destination:

  A string. Publicly accessible web address for the output PDF file.

- token:

  A string. Token generated with
  [`getToken`](http://paulgovan.github.io/AutoDeskR/reference/getToken.md)
  function with `code:all` scope.

## Value

An object containing the WorkItem `id`, `status`, and `stats`. Use `id`
with
[`checkPdf`](http://paulgovan.github.io/AutoDeskR/reference/checkPdf.md)
to poll for completion.

## Examples

``` r
if (FALSE) { # \dontrun{
mySource <- "http://download.autodesk.com/us/samplefiles/acad/visualization_-_aerial.dwg"
myDestination <- "https://example.com/output/aerial.pdf"
resp <- makePdf(mySource, myDestination, token = myToken)
myWorkItemId <- resp$content$id
} # }
```
