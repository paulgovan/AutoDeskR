# The AutoDeskR Package:
AutoDeskR is an R package that provides an interface to the:
* Authentication API for obtaining authentication to the AutoDesk Forge Platfrom.
* Data Management API for managing data across the platform's cloud services. 
* Design Automation API for performing automated tasks on design files in the cloud.
* Model Derivative API for translating design files into different formats, sending them to the viewer app, and extracting design data.

For more information about the AutoDesk Forge Platform , please visit [https://developer.autodesk.com](https://developer.autodesk.com)

# Quick Start
To install AutoDeskR in [R](https://www.r-project.org):

```
devtools::install_github('paulgovan/autodeskr')
```

# Authentication
AutoDesk uses OAuth-based authentication for access to their services. To get started with this package, first visit the [Create an App](https://developer.autodesk.com/en/docs/oauth/v2/tutorials/create-app/) tutorial for instructions on creating an app and getting a Client ID and Secret. 

We highly recommend that the Client ID, Secret, access tokens, and so on be stored in a file called `.Renviron` in the current working directory and accessing these keys with the `Sys.getenv()` function. This way potentially sensitive information is never explicitly passed to functions in this package. For more information on storing keys in the `.Renviron` file and accessing them with the `Sys.getenv()`, see the appendix in this [API Best Practices](https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html) vignette.  

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

To upload a file to the bucket, use the `uploadFile()` function.  

```
uploadFile(file = system.file("inst/samples/aerial.dwg", package = "AutoDeskR"),
    token = Sys.getenv("access_token"), bucket = "mybucket")
```

