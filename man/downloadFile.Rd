% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/modelDerivative.R
\name{downloadFile}
\alias{downloadFile}
\title{Download a file locally.}
\usage{
downloadFile(urn = NULL, output_urn = NULL, token = NULL)
}
\arguments{
\item{urn}{A string. Source URN (objectId) for the file. Note the URN must be
Base64 encoded. To encode the URN, see, for example, the
\code{jsonlite::base64_enc} function.}

\item{output_urn}{A string. Output_urn retrieved via
\code{\link{getOutputUrn}}}

\item{token}{A string. Token generated with \code{\link{getToken}} function
with \code{data:read} and \code{data:write} scopes.}
}
\value{
An object containing the \code{result}, \code{urn}, and additional
  activity information.
}
\description{
Download a file from the Forge Platform using the Model Derivative API.
}
\examples{
\dontrun{
# Download the "aerial.dwg" png file
myEncodedOutputUrn <- jsonlite::base64_enc(myOutputUrn)
resp <- downloadFile(urn <- myEncodedUrn, output_urn <- myEncodedOutputUrn, token = myToken)
}
}
