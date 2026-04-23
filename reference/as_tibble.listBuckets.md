# Convert a listBuckets Response to a Tibble.

Requires the `tibble` package.

## Usage

``` r
# S3 method for class 'listBuckets'
as_tibble(x, ...)
```

## Arguments

- x:

  A `listBuckets` response object.

- ...:

  Additional arguments (unused).

## Value

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
one row per bucket and columns `bucketKey`, `bucketOwner`, and
`policyKey`.

## Examples

``` r
if (FALSE) { # \dontrun{
library(tibble)
listBuckets(token = myToken) |> as_tibble()
} # }
```
