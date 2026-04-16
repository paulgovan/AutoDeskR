# Internal helper: return b when a is NULL
`%||%` <- function(a, b) if (!is.null(a)) a else b

#' @export
print.getToken <- function(x, ...) {
  cat("<AutoDeskR: getToken>\n")
  cat("  Token type:", x$content$token_type %||% "unknown", "\n")
  cat("  Expires in:", x$content$expires_in  %||% "unknown", "seconds\n")
  invisible(x)
}

#' @export
print.makeBucket <- function(x, ...) {
  cat("<AutoDeskR: makeBucket>\n")
  cat("  Bucket key:", x$content$bucketKey %||% "unknown", "\n")
  cat("  Policy:    ", x$content$policyKey  %||% "unknown", "\n")
  invisible(x)
}

#' @export
print.checkBucket <- function(x, ...) {
  cat("<AutoDeskR: checkBucket>\n")
  cat("  Bucket key:", x$content$bucketKey %||% "unknown", "\n")
  cat("  Policy:    ", x$content$policyKey  %||% "unknown", "\n")
  invisible(x)
}

#' @export
print.listBuckets <- function(x, ...) {
  items <- x$content$items %||% list()
  cat("<AutoDeskR: listBuckets>\n")
  cat("  Buckets found:", length(items), "\n")
  for (b in items) cat("   -", b$bucketKey %||% "unknown", "\n")
  invisible(x)
}

#' @export
print.deleteBucket <- function(x, ...) {
  cat("<AutoDeskR: deleteBucket>\n")
  cat("  Status:", x$content$status %||% "unknown", "\n")
  invisible(x)
}

#' @export
print.uploadFile <- function(x, ...) {
  cat("<AutoDeskR: uploadFile>\n")
  cat("  Object key:", x$content$objectKey %||% "unknown", "\n")
  cat("  Size:      ", x$content$size       %||% "unknown", "bytes\n")
  invisible(x)
}

#' @export
print.uploadFileSigned <- function(x, ...) {
  cat("<AutoDeskR: uploadFileSigned>\n")
  cat("  Object key:", x$content$objectKey %||% "unknown", "\n")
  cat("  Size:      ", x$content$size       %||% "unknown", "bytes\n")
  invisible(x)
}

#' @export
print.listObjects <- function(x, ...) {
  items <- x$content$items %||% list()
  cat("<AutoDeskR: listObjects>\n")
  cat("  Objects found:", length(items), "\n")
  for (o in items) cat("   -", o$objectKey %||% "unknown", "\n")
  invisible(x)
}

#' @export
print.deleteObject <- function(x, ...) {
  cat("<AutoDeskR: deleteObject>\n")
  cat("  Status:", x$content$status %||% "unknown", "\n")
  invisible(x)
}

#' @export
print.makePdf <- function(x, ...) {
  cat("<AutoDeskR: makePdf>\n")
  cat("  WorkItem ID:", x$content$id     %||% "unknown", "\n")
  cat("  Status:     ", x$content$status %||% "unknown", "\n")
  invisible(x)
}

#' @export
print.checkPdf <- function(x, ...) {
  cat("<AutoDeskR: checkPdf>\n")
  cat("  WorkItem ID:", x$content$id     %||% "unknown", "\n")
  cat("  Status:     ", x$content$status %||% "unknown", "\n")
  invisible(x)
}

#' @export
print.translateSvf <- function(x, ...) {
  cat("<AutoDeskR: translateSvf>\n")
  cat("  Result:", x$content$result %||% "unknown", "\n")
  cat("  URN:   ", x$content$urn    %||% "unknown", "\n")
  invisible(x)
}

#' @export
print.translateObj <- function(x, ...) {
  cat("<AutoDeskR: translateObj>\n")
  cat("  Result:", x$content$result %||% "unknown", "\n")
  cat("  URN:   ", x$content$urn    %||% "unknown", "\n")
  invisible(x)
}

#' @export
print.translateStl <- function(x, ...) {
  cat("<AutoDeskR: translateStl>\n")
  cat("  Result:", x$content$result %||% "unknown", "\n")
  cat("  URN:   ", x$content$urn    %||% "unknown", "\n")
  invisible(x)
}

#' @export
print.checkFile <- function(x, ...) {
  cat("<AutoDeskR: checkFile>\n")
  cat("  Status:  ", x$content$status   %||% "unknown", "\n")
  cat("  Progress:", x$content$progress %||% "unknown", "\n")
  invisible(x)
}

#' @export
print.getMetadata <- function(x, ...) {
  items <- x$content$data$metadata %||% list()
  cat("<AutoDeskR: getMetadata>\n")
  cat("  Viewables found:", length(items), "\n")
  for (m in items) cat("   -", m$name %||% "unknown", "(guid:", m$guid %||% "unknown", ")\n")
  invisible(x)
}

#' @export
print.getData <- function(x, ...) {
  cat("<AutoDeskR: getData>\n")
  cat("  Properties returned:", length(x$content$data$collection %||% list()), "\n")
  invisible(x)
}

#' @export
print.getObjectTree <- function(x, ...) {
  cat("<AutoDeskR: getObjectTree>\n")
  cat("  Object count:", x$content$data$objects[[1]]$objectCount %||% "unknown", "\n")
  invisible(x)
}

#' @export
print.getOutputUrn <- function(x, ...) {
  cat("<AutoDeskR: getOutputUrn>\n")
  cat("  Status:  ", x$content$status   %||% "unknown", "\n")
  cat("  Progress:", x$content$progress %||% "unknown", "\n")
  invisible(x)
}

#' @export
print.downloadFile <- function(x, ...) {
  cat("<AutoDeskR: downloadFile>\n")
  if (!is.null(x$content$destfile)) {
    cat("  Saved to:", x$content$destfile, "\n")
  } else {
    cat("  Content type: JSON\n")
  }
  invisible(x)
}
