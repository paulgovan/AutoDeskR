# The AutoDeskR Package:
AutoDeskR is an R package that provides an interface to the:
* Authentication API for obtaining authentication to the AutoDesk Forge Platfrom.
* Data Management API for managing data across the platform's cloud services. 
* Design Automation API for performing automated tasks on design files in the cloud.
* Model Derivative API for translating design files into different formats, sending them to the viewer app, and extracting design data.

For more information about the AutoDesk Forge Platform, please visit [https://developer.autodesk.com](https://developer.autodesk.com)

# Quick Start
To install AutoDeskR in [R](https://www.r-project.org):

```
devtools::install_github('paulgovan/autodeskr')
```

# Authentication
AutoDesk uses OAuth-based authentication for access to their services. To get started with this package, first visit the [Create an App](https://developer.autodesk.com/en/docs/oauth/v2/tutorials/create-app/) tutorial for instructions on creating an app and getting a Client ID and Secret. 

We highly recommend that the Client ID, Secret, access tokens, and so on be stored in a file called `.Renviron` in the current working directory and accessing these keys with the `Sys.getenv()` function. This way potentially sensitive information is never explicitly passed to functions in this package. For more information on storing keys in the `.Renviron` file and accessing them with `Sys.getenv()`, see the appendix in this [API Best Practices](https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html) vignette.  

To get an access token, use the `getToken()` function, which returns an object with the `access_token`, `type`, and `expires_in` variables.:

```
getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"))
```

# Data Management
## Create a Bucket and Upload a File
Design files are hosted in the cloud and organized into buckets. To create a bucket, first get a token with the `bucket:create`, `bucket:read`, and `data:write` scopes. 

```
getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"), 
    scope = "bucket:create bucket:read data:write")
```

Then use the `makeBucket()` function to create a bucket, where "access_token" is generated with the `getToken()` function and `bucket` is a name for the bucket. 

```
makeBucket(token = Sys.getenv("access_token"), bucket = "mybucket")
```

To check the status of a bucket:

```
checkBucket(token = Sys.getenv("access_token"), bucket = "mybucket")
```

Finally, to upload a file to the bucket, use the `uploadFile()` function, which returns an object containing the `bucketKey`, `objectId` (i.e. urn), `objectKey` (i.e. file name), `size`, `contentType` (i.e. "application/octet-stream"), `location` and other content information. Note the unique urn of the file and store it in `.Renviron` for future use. 

```
uploadFile(file = system.file("inst/samples/aerial.dwg", package = "AutoDeskR"),
    token = Sys.getenv("access_token"), bucket = "mybucket")
```

# Design Automation
##  Convert a DWG File to a PDF File
To convert a DWG file to a PDF file, use the `makePdf` function, where `source` and `destination` are the publicly accessible source of the DWG file and destination for the PDF file, respectively. 

```
mySource <- "http://download.autodesk.com/us/samplefiles/acad/visualization_-_aerial.dwg"
myDestination <- "https://drive.google.com/folderview?id=0BygncDVHf60mTDZVNDltLThLNmM&usp=sharing"
makePdf(mySource, myDestination, token = Sys.getenv("access_token"))
```

Note that in this example, the "access_token" must be generated with the `code:all` scope.


To check the status of the conversion process:

```
checkPdf(mySource, myDestination, token = Sys.getenv("access_token"))
```

# Model Derivative
## Prepare a File for the Viewer
To prepare a file for the viewer, first get an access token with the `data:read` and `data:write` scopes.

```
getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"), 
    scope = "data:read data:write")
```

AutoDesk requires that the urn of the file be Base-64 encoded. Fortunately, the `jsonlite` package has a nifty function for encoding the urn. 

```
myURN <- jsonlite::base64_enc(Sys.getenv("urn"))
```

Then, translate the file into the SVF format:

```
translateSvf(urn <- myUrn, token = Sys.getenv("access_token"))
```

To check the status of the translation process:

```
checkFile(urn <- myUrn, token = Sys.getenv("access_token"))
```

Finally, embed the urn of the file in the viewer, which will be described later on.

## Extract Data from a File
To extract data from a file, get a token with the `data:read` and `data:write` scopes, encode the urn of the file using the `jsonlite::base64_enc()` function, and translate the file into the SVF format using the `translateSvf` function.  Next, retrieve the metadata for a file using the `getMetadata()` function, which returns an object with the `type`, `name`, and `guid` of the file. Note the `guid` and store it in `.Renviron`.

```
getMetadata(urn <- myUrn, token = Sys.getenv("access_token"))
```

Finally, get the properties of the file with the `getData()` function.

```
getData(guid <- Sys.getenv("guid"), urn <- myUrn, token = Sys.getenv("access_token"))
```

## Extract Geometry from a File
To get the object tree of a file, follow the previous instructions for extracting data from a file, and note the "guid", "urn", and "access_token". Then use the `getObjectTree()` function.

```
getObjectTree(guid <- Sys.getenv("guid"), urn <- myUrn, token = Sys.getenv("token"))
```
