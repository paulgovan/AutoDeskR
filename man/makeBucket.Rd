% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataManagement.R
\name{makeBucket}
\alias{makeBucket}
\title{Make a Bucket for an App.}
\usage{
makeBucket(token = NULL, bucket = "mybucket", policy = "transient")
}
\arguments{
\item{token}{A string. Token generated with \code{\link{getToken}} function
with \code{bucket:create}, \code{bucket:read}, and \code{data:write}
scopes.}

\item{bucket}{A string. Unique bucket name. Defaults to \code{mybucket}.}

\item{policy}{A string. May be \code{transient}, \code{temporary}, or
\code{persistent}.}
}
\value{
An object containing the \code{bucketKey}, \code{bucketOwner}, and
  \code{createdDate}.
}
\description{
Make an app-based bucket for storage of design files using the Data Management API.
}
\examples{
\dontrun{
# Make a transient bucket with the name "mybucket"
resp <- makeBucket(token = myToken, bucket = "mybucket", policy = "transient")
}
}
