# Create a Photoscene for Reality Capture.

Create a new photoscene for photogrammetry processing using the Reality
Capture API. Upload images with
[`uploadImages`](http://paulgovan.github.io/AutoDeskR/reference/uploadImages.md),
then start processing with
[`processPhotoscene`](http://paulgovan.github.io/AutoDeskR/reference/processPhotoscene.md).

## Usage

``` r
createPhotoscene(name = NULL, format = "rcm", token = NULL)
```

## Arguments

- name:

  A string. Name for the photoscene.

- format:

  A string. Output format. One of `"rcm"`, `"rcs"`, `"obj"`, `"ortho"`,
  or `"report"`. Defaults to `"rcm"`.

- token:

  A string or `aps_token` object with `data:read` and `data:write`
  scopes.

## Value

An object of class `createPhotoscene` containing the `photosceneid` at
`resp$content$photoscene$photosceneid`.

## Examples

``` r
if (FALSE) { # \dontrun{
ps <- createPhotoscene(name = "my-scene", format = "obj", token = myToken)
myPhotosceneId <- ps$content$photoscene$photosceneid
} # }
```
