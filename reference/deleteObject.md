# Delete an Object from an App-Managed Bucket.

Delete an object from an app-managed bucket using the Data Management
API.

## Usage

``` r
deleteObject(token = NULL, bucket = "mybucket", object = NULL)
```

## Arguments

- token:

  A string. Token generated with
  [`getToken`](http://paulgovan.github.io/AutoDeskR/reference/getToken.md)
  function with `data:write` scope.

- bucket:

  A string. Name of the bucket. Defaults to `mybucket`.

- object:

  A string. Key (name) of the object to delete.

## Value

An object containing the HTTP status code of the response.

## Examples

``` r
if (FALSE) { # \dontrun{
# Delete the "aerial.dwg" object from "mybucket"
resp <- deleteObject(token = myToken, bucket = "mybucket", object = "aerial.dwg")
} # }
```
