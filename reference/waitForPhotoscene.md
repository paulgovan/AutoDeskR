# Wait for Reality Capture Processing to Complete.

Polls
[`checkPhotoscene`](https://paulgovan.github.io/AutoDeskR/reference/checkPhotoscene.md)
at a fixed interval until processing reaches 100% or an error occurs.

## Usage

``` r
waitForPhotoscene(
  photoscene_id,
  token,
  interval = 30,
  timeout = 1800,
  verbose = TRUE
)
```

## Arguments

- photoscene_id:

  A string. Photoscene ID returned by
  [`createPhotoscene`](https://paulgovan.github.io/AutoDeskR/reference/createPhotoscene.md).

- token:

  A string or `aps_token` object.

- interval:

  Seconds between polls. Defaults to `30`.

- timeout:

  Maximum seconds to wait before aborting. Defaults to `1800` (30
  minutes).

- verbose:

  If `TRUE` (default), prints a message after each poll.

## Value

The final
[`checkPhotoscene`](https://paulgovan.github.io/AutoDeskR/reference/checkPhotoscene.md)
response object.

## Examples

``` r
if (FALSE) { # \dontrun{
ps   <- createPhotoscene("my-scene", token = myToken)
id   <- ps$content$photoscene$photosceneid
imgs <- uploadImages(id, c("img1.jpg", "img2.jpg"), myToken)
proc <- processPhotoscene(id, myToken)
done <- waitForPhotoscene(id, myToken)
done$content$photoscene$progress
} # }
```
