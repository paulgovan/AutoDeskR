# Wait for a Model Derivative Translation to Complete.

Polls
[`checkFile`](https://paulgovan.github.io/AutoDeskR/reference/checkFile.md)
at a fixed interval until the translation reaches a terminal state
(`"success"`, `"failed"`, or `"timeout"`).

## Usage

``` r
waitForFile(urn, token, interval = 5, timeout = 300, verbose = TRUE)
```

## Arguments

- urn:

  A string. Base64-encoded source URN.

- token:

  A string or `aps_token` object with `data:read` scope.

- interval:

  Seconds between polls. Defaults to `5`.

- timeout:

  Maximum seconds to wait before aborting. Defaults to `300`.

- verbose:

  If `TRUE` (default), prints a message after each poll.

## Value

The final
[`checkFile`](https://paulgovan.github.io/AutoDeskR/reference/checkFile.md)
response object.

## Examples

``` r
if (FALSE) { # \dontrun{
myEncodedUrn <- jsonlite::base64_enc(myUrn)
resp <- translateSvf(urn = myEncodedUrn, token = myToken)
done <- waitForFile(urn = myEncodedUrn, token = myToken)
done$content$status
} # }
```
