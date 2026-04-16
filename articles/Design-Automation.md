# Design-Automation

## Design Automation

The Design Automation API provides users the ability to perform
automated tasks on design files in the cloud.

### Convert a DWG File to a PDF File

To convert a DWG file to a PDF file, use the `makePdf` function, where
`source` and `destination` are the publicly accessible source of the DWG
file and destination for the PDF file, respectively.

``` c
mySource <- "http://download.autodesk.com/us/samplefiles/acad/visualization_-_aerial.dwg"
myDestination <- "https://drive.google.com/folderview?id=0BygncDVHf60mTDZVNDltLThLNmM&usp=sharing"
resp <- makePdf(source = mySource, destination = myDestination, token = myToken)
```

Note that in this example, the `token` must be generated with the
`code:all` scope.

To check the status of the conversion process, use the WorkItem `id`
returned by
[`makePdf()`](http://paulgovan.github.io/AutoDeskR/reference/makePdf.md):

``` c
myWorkItemId <- resp$content$id
resp <- checkPdf(id = myWorkItemId, token = myToken)
resp
```
