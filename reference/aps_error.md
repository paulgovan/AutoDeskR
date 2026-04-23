# Create an APS API Error Condition.

Create a structured error condition for failures returned by the
AutoDesk Platform Services (APS) API. Callers can use
`tryCatch(..., aps_error = function(e) ...)` to handle these errors.

## Usage

``` r
aps_error(message, status, body, call = sys.call(-1))
```

## Arguments

- message:

  A string. Human-readable error message.

- status:

  An integer. HTTP status code.

- body:

  A list. Parsed JSON body of the error response.

- call:

  The call where the error occurred (internal use).

## Value

A condition object of class `c("aps_error", "error", "condition")`.

## Examples

``` r
if (FALSE) { # \dontrun{
tryCatch(
  makeBucket(token = "bad_token"),
  aps_error = function(e) cat("HTTP", e$status, "-", e$message)
)
} # }
```
