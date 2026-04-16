# Viewer

### Prepare a File for the Viewer

To prepare a file for the online viewer, first get an access token with
the `data:read` and `data:write` scopes.

``` c
resp <- getToken(id = Sys.getenv("client_id"), secret = Sys.getenv("client_secret"), 
            scope = "data:read data:write")
myToken <- resp$content$access_token
```

Nex, encode the urn using the
[`jsonlite::base64_enc()`](https://jeroen.r-universe.dev/jsonlite/reference/base64.html)
function.

``` c
myEncodedUrn <- jsonlite::base64_enc(myUrn)
```

Then, translate the file into SVF format:

``` c
resp <- translateSvf(urn = myEncodedUrn, token = myToken)
```

To check the status of the translation process:

``` c
resp <- checkFile(urn = myEncodedUrn, token = myToken)
resp
```

Finally, embed the urn of the file in the viewer, which is described in
the **Viewer** section.

### Extract Data from a File

To extract data from a file, follow the steps in the previous section
for getting a token with the `data:read` and `data:write` scopes,
encoding the `urn` of the file using the
[`jsonlite::base64_enc()`](https://jeroen.r-universe.dev/jsonlite/reference/base64.html)
function, and translating the file into SVF format using the
[`translateSvf()`](http://paulgovan.github.io/AutoDeskR/reference/translateSvf.md)
function. Next, retrieve metadata for a file using the
[`getMetadata()`](http://paulgovan.github.io/AutoDeskR/reference/getMetadata.md)
function, which returns an object with the `type`, `name`, and `guid` of
the file. Note the `guid` and store it in `.Renviron`.

``` c
resp <- getMetadata(urn = myEncodedUrn, token = myToken)
myGuid <- resp$content$data$metadata[[1]]$guid
```

To get the object tree of a model, use the
[`getObjectTree()`](http://paulgovan.github.io/AutoDeskR/reference/getObjectTree.md)
function.

``` c
resp <- getObjectTree(guid = myGuid, urn = myEncodedUrn, token = myToken)
resp
```

To extract data from the model, use the
[`getData()`](http://paulgovan.github.io/AutoDeskR/reference/getData.md)
function.

``` c
resp <- getData(guid = myGuid, urn = myEncodedUrn, token = myToken)
```

## Viewer

AutoDesk provides a WebGL-based viewer for rendering 2D and 3D models.
To use the viewer, make sure to first follow the instructions in
**Prepare a File for the Viewer** above. Then simply pass the `urn` of
the file and the `token` to the
[`viewer3D()`](http://paulgovan.github.io/AutoDeskR/reference/viewer3D.md)
function:

``` c
viewer3D(urn = myEncodedUrn, token = myToken)
```

![](https://github.com/paulgovan/AutoDeskR/blob/master/inst/images/aerial.png?raw=true)

The viewer can also be embedded in Shiny applications, interactive R
markdown documents, and other web pages thanks to the Shiny Modules
framework. Here is a simple example of a Shiny app and the
[`viewerUI()`](http://paulgovan.github.io/AutoDeskR/reference/viewerUI.md)
function:

``` c
ui <- function(request) {
 shiny::fluidPage(
   viewerUI("pg", myEncodedUrn, myToken)
 )
}
server <- function(input, output, session) {
}
shiny::shinyApp(ui, server)
```
