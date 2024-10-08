% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/modelDerivative.R
\name{getData}
\alias{getData}
\title{Get the Geometry Data for a File.}
\usage{
getData(guid = NULL, urn = NULL, token = NULL)
}
\arguments{
\item{guid}{A string. GUID retrieved via the \code{\link{getMetadata}}
function.}

\item{urn}{A string. Source URN (objectId) for the file. Note the URN must be
Base64 encoded. To encode the URN, see, for example, the
\code{jsonlite::base64_enc} function.}

\item{token}{A string. Token generated with \code{\link{getToken}} function
with \code{data:read} and \code{data:write} scopes.}
}
\value{
An object containing the geometry data for the selected file.
}
\description{
Get the geometry of an uploaded file using the Model Derivative API.
}
\examples{
\dontrun{
# Get the geometry data for the "aerial.dwg" svf file
resp <- getData(guid <- myGuid, urn <- myEncodedUrn, token = myToken)
}
}
