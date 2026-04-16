# Authentication

## Authentication

AutoDesk uses OAuth-based authentication for access to their services.
To get started with this package, first visit the **Create an App**
tutorial at
<https://aps.autodesk.com/en/docs/oauth/v2/tutorials/create-app/> for
instructions on creating an app and getting a Client ID and Secret.

We highly recommend that the Client ID, Secret, and access tokens be
stored in a file called `.Renviron` and accessing these keys with the
[`Sys.getenv()`](https://rdrr.io/r/base/Sys.getenv.html) function. This
step is a possible solution for preventing authentication information
from being in a publicly accessible location (e.g. GitHub repo). For
more information on storing keys in the `.Renviron` file and accessing
them with [`Sys.getenv()`](https://rdrr.io/r/base/Sys.getenv.html), see
[Wrapping APIs](https://httr2.r-lib.org/articles/wrapping-apis.html)
from the httr2 documentation.

To get an access token, use the
[`getToken()`](http://paulgovan.github.io/AutoDeskR/reference/getToken.md)
function, which returns an object with the `access_token`, `type`, and
`expires_in` variables.:

``` c
resp <- getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"))
myToken <- resp$content$access_token
```
