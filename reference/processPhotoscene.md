# Start Reality Capture Processing.

Initiate photogrammetry processing for a photoscene that has had images
uploaded via
[`uploadImages`](http://paulgovan.github.io/AutoDeskR/reference/uploadImages.md).

## Usage

``` r
processPhotoscene(photoscene_id = NULL, token = NULL)
```

## Arguments

- photoscene_id:

  A string. Photoscene ID returned by
  [`createPhotoscene`](http://paulgovan.github.io/AutoDeskR/reference/createPhotoscene.md).

- token:

  A string or `aps_token` object with `data:read` and `data:write`
  scopes.

## Value

An object of class `processPhotoscene` containing the processing
response.

## Examples

``` r
if (FALSE) { # \dontrun{
proc <- processPhotoscene(photoscene_id = myPhotosceneId, token = myToken)
} # }
```
