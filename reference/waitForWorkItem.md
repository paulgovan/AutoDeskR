# Wait for a Design Automation WorkItem to Complete.

Polls
[`checkPdf`](https://paulgovan.github.io/AutoDeskR/reference/checkPdf.md)
at a fixed interval until the WorkItem reaches a terminal state (any
status other than `"inprogress"` or `"pending"`).

## Usage

``` r
waitForWorkItem(id, token, interval = 5, timeout = 300, verbose = TRUE)
```

## Arguments

- id:

  A string. WorkItem ID from `makePdf()$content$id`.

- token:

  A string or `aps_token` object with `code:all` scope.

- interval:

  Seconds between polls. Defaults to `5`.

- timeout:

  Maximum seconds to wait before aborting. Defaults to `300`.

- verbose:

  If `TRUE` (default), prints a message after each poll.

## Value

The final
[`checkPdf`](https://paulgovan.github.io/AutoDeskR/reference/checkPdf.md)
response object.

## Examples

``` r
if (FALSE) { # \dontrun{
resp <- makePdf(source = mySource, destination = myDest, token = myToken)
done <- waitForWorkItem(id = resp$content$id, token = myToken)
done$content$status
} # }
```
