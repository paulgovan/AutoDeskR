# Upload Images to a Photoscene.

Upload one or more image files to an existing photoscene for Reality
Capture processing.

## Usage

``` r
uploadImages(photoscene_id = NULL, files = NULL, token = NULL)
```

## Arguments

- photoscene_id:

  A string. Photoscene ID returned by
  [`createPhotoscene`](http://paulgovan.github.io/AutoDeskR/reference/createPhotoscene.md).

- files:

  A character vector. Local file paths to image files (JPEG or PNG).

- token:

  A string or `aps_token` object with `data:read` and `data:write`
  scopes.

## Value

An object of class `uploadImages` containing the upload response.

## Examples

``` r
if (FALSE) { # \dontrun{
imgs <- uploadImages(
  photoscene_id = myPhotosceneId,
  files         = c("img1.jpg", "img2.jpg", "img3.jpg"),
  token         = myToken
)
} # }
```
