# Convert a listObjects Response to a Tibble.

Requires the `tibble` package.

## Usage

``` r
# S3 method for class 'listObjects'
as_tibble(x, ...)
```

## Arguments

- x:

  A `listObjects` response object.

- ...:

  Additional arguments (unused).

## Value

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
one row per object and columns `objectKey`, `objectId`, `size`, and
`location`.

## Examples

``` r
if (FALSE) { # \dontrun{
library(tibble)
listObjects(token = myToken, bucket = "mybucket") |> as_tibble()
} # }
```
