# Check Reality Capture Processing Progress.

Poll the processing status of a photoscene. Use
[`waitForPhotoscene`](https://paulgovan.github.io/AutoDeskR/reference/waitForPhotoscene.md)
to block until processing completes.

## Usage

``` r
checkPhotoscene(photoscene_id = NULL, token = NULL)
```

## Arguments

- photoscene_id:

  A string. Photoscene ID returned by
  [`createPhotoscene`](https://paulgovan.github.io/AutoDeskR/reference/createPhotoscene.md).

- token:

  A string or `aps_token` object with `data:read` and `data:write`
  scopes.

## Value

An object of class `checkPhotoscene` containing
`resp$content$photoscene$progress` (percentage string) and
`resp$content$photoscene$progressmsg`.

## Examples

``` r
if (FALSE) { # \dontrun{
status <- checkPhotoscene(photoscene_id = myPhotosceneId, token = myToken)
status$content$photoscene$progress
} # }
```
