# Package index

## Authentication

- [`getToken()`](https://paulgovan.github.io/AutoDeskR/reference/getToken.md)
  : Get a 2-Legged Token for Authentication.

## Data Management

- [`makeBucket()`](https://paulgovan.github.io/AutoDeskR/reference/makeBucket.md)
  : Make a Bucket for an App.
- [`checkBucket()`](https://paulgovan.github.io/AutoDeskR/reference/checkBucket.md)
  : Check the Status of an App-Managed Bucket.
- [`deleteBucket()`](https://paulgovan.github.io/AutoDeskR/reference/deleteBucket.md)
  : Delete an App-Managed Bucket.
- [`uploadFile()`](https://paulgovan.github.io/AutoDeskR/reference/uploadFile.md)
  : Upload a File to an App-Managed Bucket.
- [`uploadFileSigned()`](https://paulgovan.github.io/AutoDeskR/reference/uploadFileSigned.md)
  : Upload a File Using Signed S3 URLs.
- [`listBuckets()`](https://paulgovan.github.io/AutoDeskR/reference/listBuckets.md)
  : List All App-Managed Buckets.
- [`listObjects()`](https://paulgovan.github.io/AutoDeskR/reference/listObjects.md)
  : List Objects in an App-Managed Bucket.
- [`deleteObject()`](https://paulgovan.github.io/AutoDeskR/reference/deleteObject.md)
  : Delete an Object from an App-Managed Bucket.

## Design Automation

- [`makePdf()`](https://paulgovan.github.io/AutoDeskR/reference/makePdf.md)
  : Convert a DWG to a PDF.
- [`checkPdf()`](https://paulgovan.github.io/AutoDeskR/reference/checkPdf.md)
  : Check the Status of a PDF WorkItem.

## Model Derivative

- [`translateSvf()`](https://paulgovan.github.io/AutoDeskR/reference/translateSvf.md)
  : Translate a File into SVF Format.
- [`translateSvf2()`](https://paulgovan.github.io/AutoDeskR/reference/translateSvf2.md)
  : Translate a File into SVF2 Format.
- [`translateObj()`](https://paulgovan.github.io/AutoDeskR/reference/translateObj.md)
  : Translate a File into OBJ Format.
- [`translateStl()`](https://paulgovan.github.io/AutoDeskR/reference/translateStl.md)
  : Translate a File into STL Format.
- [`checkFile()`](https://paulgovan.github.io/AutoDeskR/reference/checkFile.md)
  : Check the Status of a Translated File.
- [`getMetadata()`](https://paulgovan.github.io/AutoDeskR/reference/getMetadata.md)
  : Get the Metadata for a File.
- [`getData()`](https://paulgovan.github.io/AutoDeskR/reference/getData.md)
  : Get the Geometry Data for a File.
- [`getObjectTree()`](https://paulgovan.github.io/AutoDeskR/reference/getObjectTree.md)
  : Get the Object Tree of a File.
- [`getOutputUrn()`](https://paulgovan.github.io/AutoDeskR/reference/getOutputUrn.md)
  : Get the Output URN for a File.
- [`downloadFile()`](https://paulgovan.github.io/AutoDeskR/reference/downloadFile.md)
  : Download a file locally.

## Reality Capture

- [`createPhotoscene()`](https://paulgovan.github.io/AutoDeskR/reference/createPhotoscene.md)
  : Create a Photoscene for Reality Capture.
- [`uploadImages()`](https://paulgovan.github.io/AutoDeskR/reference/uploadImages.md)
  : Upload Images to a Photoscene.
- [`processPhotoscene()`](https://paulgovan.github.io/AutoDeskR/reference/processPhotoscene.md)
  : Start Reality Capture Processing.
- [`checkPhotoscene()`](https://paulgovan.github.io/AutoDeskR/reference/checkPhotoscene.md)
  : Check Reality Capture Processing Progress.
- [`waitForPhotoscene()`](https://paulgovan.github.io/AutoDeskR/reference/waitForPhotoscene.md)
  : Wait for Reality Capture Processing to Complete.

## Viewer

- [`viewer3D()`](https://paulgovan.github.io/AutoDeskR/reference/viewer3D.md)
  : Launch the Viewer.
- [`viewerUI()`](https://paulgovan.github.io/AutoDeskR/reference/viewerUI.md)
  : UI Module Function.

## MCP Tools

- [`autodeskr_mcp_tools()`](https://paulgovan.github.io/AutoDeskR/reference/autodeskr_mcp_tools.md)
  : MCP tools for AutoDeskR

## Utilities

- [`waitForFile()`](https://paulgovan.github.io/AutoDeskR/reference/waitForFile.md)
  : Wait for a Model Derivative Translation to Complete.
- [`waitForWorkItem()`](https://paulgovan.github.io/AutoDeskR/reference/waitForWorkItem.md)
  : Wait for a Design Automation WorkItem to Complete.
- [`is_expired()`](https://paulgovan.github.io/AutoDeskR/reference/is_expired.md)
  : Check Whether an aps_token Has Expired.
- [`aps_error()`](https://paulgovan.github.io/AutoDeskR/reference/aps_error.md)
  : Create an APS API Error Condition.
- [`as_tibble(`*`<listBuckets>`*`)`](https://paulgovan.github.io/AutoDeskR/reference/as_tibble.listBuckets.md)
  : Convert a listBuckets Response to a Tibble.
- [`as_tibble(`*`<listObjects>`*`)`](https://paulgovan.github.io/AutoDeskR/reference/as_tibble.listObjects.md)
  : Convert a listObjects Response to a Tibble.
