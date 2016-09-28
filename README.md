![AutoDeskR](https://github.com/paulgovan/AutoDeskR/blob/master/inst/images/basicSample.png?raw=true)

# The AutoDeskR Package
AutoDeskR is an R package that provides an interface to the:
* Authentication API for obtaining authentication to the AutoDesk Forge Platfrom.
* Data Management API for managing data across the platform's cloud services. 
* Design Automation API for performing automated tasks on model files in the cloud.
* Model Derivative API for translating design files into different formats, sending them to the viewer app, and extracting model data.
* Viewer for rendering 2D and 3D models.

For more information about the AutoDesk Forge Platform, please visit [https://developer.autodesk.com](https://developer.autodesk.com)

# Quick Start
To install AutoDeskR in [R](https://www.r-project.org):

```
devtools::install_github('paulgovan/autodeskr')
```

# Authentication
AutoDesk uses OAuth-based authentication for access to their services. To get started with this package, first visit the [Create an App](https://developer.autodesk.com/en/docs/oauth/v2/tutorials/create-app/) tutorial for instructions on creating an app and getting a Client ID and Secret. 

We highly recommend that the Client ID, Secret, access tokens, and other keys be stored in a file called `.Renviron` and accessing these keys with the `Sys.getenv()` function. This way potentially sensitive information is never explicitly passed to functions in this package. For more information on storing keys in the `.Renviron` file and accessing them with `Sys.getenv()`, see the appendix in this [API Best Practices](https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html) vignette.  

To get an access token, use the `getToken()` function, which returns an object with the `access_token`, `type`, and `expires_in` variables.:

```
resp <- getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"))
myToken <- resp$content$access_token
```

# Data Management
## Create a Bucket and Upload a File
The Data Management API provides a way to store and access data on the platform. Model files are hosted in the cloud and organized into buckets. To create a bucket, first get a token with the `bucket:create`, `bucket:read`, and `data:write` scopes. 

```
resp <- getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"), 
            scope = "bucket:create bucket:read data:write")
myToken <- resp$content$access_token
```

Then use the `makeBucket()` function to create a bucket, where `bucket` is a name for the bucket. 

```
resp <- makeBucket(token = myToken, bucket = "mybucket")
resp
```

To check the status of a bucket:

```
resp <- checkBucket(token = myToken, bucket = "mybucket")
resp
```

Finally, to upload a file to the bucket, use the `uploadFile()` function, which returns an object containing the `bucketKey`, `objectId` (i.e. urn), `objectKey` (i.e. file name), `size`, `contentType` (i.e. "application/octet-stream"), `location` and other content information. Note the unique urn of the file and store it in `.Renviron` for future use. 

```
resp <- uploadFile(file = system.file("inst/samples/aerial.dwg", package = "AutoDeskR"),
            token = myToken, bucket = "mybucket")
myUrn <- resp$content$objectId
```

# Design Automation
##  Convert a DWG File to a PDF File
The Design Automation API provides the ability to run automated scripts on design files. For example, to convert a DWG file to a PDF file, use the `makePdf` function, where `source` and `destination` are the publicly accessible source of the DWG file and destination for the PDF file, respectively. 

```
mySource <- "http://download.autodesk.com/us/samplefiles/acad/visualization_-_aerial.dwg"
myDestination <- "https://drive.google.com/folderview?id=0BygncDVHf60mTDZVNDltLThLNmM&usp=sharing"
resp <- makePdf(mySource, myDestination, token = myToken)
```

Note that in this example, the "access_token" must be generated with the `code:all` scope.


To check the status of the conversion process:

```
resp <- checkPdf(mySource, myDestination, token = myToken)
resp
```

# Model Derivative
The Model Derivative API enables users to translate their designs into different formats and extract valuable data.

## Translate a File into OBJ Format
To translate a file into OBJ format, first get an access token with the `data:read` and `data:write` scopes.

```
resp <- getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"), 
            scope = "data:read data:write")
myToken <- resp$content$access_token
```

The AutoDesk platform requires that the urn of the file be Base-64 encoded. Fortunately, the `jsonlite` package has a nifty function for encoding the urn. 

```
# Here myUrn was generated from the 'uploadFile()' function
myEncodedUrn <- jsonlite::base64_enc(myUrn) 
```

Then, translate the file into OBJ format:

```
resp <- translateSvf(urn <- myEncodedUrn, token = myToken)
```

To check the status of the translation process:

```
resp <- checkFile(urn <- myEncodedUrn, token = myToken)
resp
```

To download an OBJ file locally, we need the "output_urn" of the translated file, which is different than the "urn" of the source file. In this case, use the `getOutputUrn()` function, which returns an object containing the `result`, output `urn` and other activity information.

```
resp <- getOutputUrn(urn <- myUrn, token = Sys.getenv("token"))
resp
```

Depending on the type of file and translation process, the response may contain multiple output `urn`s for different file types (e.g. obj, svf, png). In order to find the correct OBJ file, look through the `resp` object for a `urn` than ends in ".obj" and assign this `urn` to `myOutputUrn`, similar to the following:

```
myOutputUrn < "urn:adsk.viewing:fs.file:dXJuOmFkc2sub2JqZWN0czpvcy5vYmplY3Q6bW9kZWxkZXJpdmF0aXZlL0E1LmlhbQ/output/geometry/bc3339b2-73cd-4fba-9cb3-15363703a354.obj"
```

Finally, to download the OBJ file locally:

```
myEncodedOutputUrn <- jsonlite::base64_enc(myOutputUrn)
resp <- downloadFile(urn <- myEncodedUrn, output_urn <- myEncodedOutputUrn, token = myToken)
```

## Prepare a File for the Viewer
To prepare a file for the online viewer, first get an access token with the `data:read` and `data:write` scopes.

```
resp <- getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"), 
            scope = "data:read data:write")
myToken <- resp$content$access_token
```

Nex, encode the urn using the `jsonlite::base64_enc()` function. 

```
myEncodedUrn <- jsonlite::base64_enc(myUrn)
```

Then, translate the file into SVF format:

```
resp <- translateSvf(urn <- myEncodedUrn, token = myToken)
```

To check the status of the translation process:

```
resp <- checkFile(urn <- myEncodedUrn, token = myToken)
resp
```

Finally, embed the urn of the file in the viewer, which is described in the **Viewer** section.

## Extract Data from a File
To extract data from a file, follow the steps in the previous section for getting a token with the `data:read` and `data:write` scopes, encoding the `urn` of the file using the `jsonlite::base64_enc()` function, and translating the file into SVF format using the `translateSvf()` function.  Next, retrieve metadata for a file using the `getMetadata()` function, which returns an object with the `type`, `name`, and `guid` of the file. Note the `guid` and store it in `.Renviron`.

```
resp <- getMetadata(urn <- myEncodedUrn, token = myToken)
myGuid <- resp$content$data$metadata[[1]]$guid
```

Then extract data from the model with the `getData()` function.

```
resp <- getData(guid <- myGuid, urn <- myEncodedUrn, token = myToken)
```

## Extract Geometry from a File
To get the object tree of a file, follow the steps in the previous section for extracting data from a file, and note the `guid` and `urn`. Then use the `getObjectTree()` function.

```
resp <- getObjectTree(guid <- myGuid, urn <- myEncodedUrn, token = myToken)
resp
```

# Viewer
AutoDesk provides a WebGL-based viewer for rendering 2D and 3D models. To use the viewer, make sure to first follow the instructions in **Prepare a File for the Viewer** above. Then simply pass the `urn` of the file and the `access_token` to the `viewer3D()` function:

```
viewer3D(urn = myEncodedUrn, token = myToken)
```

And voila! We can view 2D and 3D models in R!

The viewer can also be embedded in Shiny applications, interactive R markdown documents, and other web pages thanks to the Shiny Modules framework. Here is a simple example of a Shiny app and the `viewerUI()` function:

```
ui <- function(request) {
 shiny::fluidPage(
   viewerUI("pg", myEncodedUrn, myToken)
 )
}
server <- function(input, output, session) {
}
shiny::shinyApp(ui, server)
```

# Acknowledgements
Many thanks to the developers at [AutoDesk](https://github.com/Developer-Autodesk) for providing this great set of tools and for the support needed to learn and implement these APIs.

# Issues
This project is in its *very* early stages. Please let us know if there are any issues using the GitHub issue tracker at [https://github.com/paulgovan/AutoDeskR/issues](https://github.com/paulgovan/AutoDeskR/issues)

# Contributions
Contributions are welcome by sending a [pull request](https://github.com/paulgovan/AutoDeskR/pulls)

# License
AutoDeskR is licensed under the [Apache](http://www.apache.org/licenses/LICENSE-2.0) licence. &copy; Paul Govan (2016)
