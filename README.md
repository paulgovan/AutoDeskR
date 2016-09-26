# The AutoDeskR Package:
This package provides an interface to the:
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
AutoDesk uses OAuth based authentication for access to their services. To get started with this package, first visit [https://developer.autodesk.com/en/docs/oauth/v2/tutorials/create-app/](https://developer.autodesk.com/en/docs/oauth/v2/tutorials/create-app/) for instructions on creating an app and getting a Client ID and Secret. 

Recommended best practice is to store the Client ID and Secret in a file called \code{.Renviron} and save this file in the current working directory.  See the appendix in [https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html](https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html) for more information on storing the Client ID, Secret, access tokens, and so on in the \code{.Renviron} file. 

Assuming the Client ID and Secret are stored in \code{.Renviron} file as \code{client_id} and \{client_secret}, respectively, to get a 2-legged token:

```
getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"))
```

