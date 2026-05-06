.aps_token_cache <- new.env(parent = emptyenv())

.aps_session_token <- function() {
  tok <- .aps_token_cache$token
  if (is.null(tok) || is_expired(tok)) {
    id     <- Sys.getenv("APS_CLIENT_ID",     unset = NA_character_)
    secret <- Sys.getenv("APS_CLIENT_SECRET", unset = NA_character_)
    if (is.na(id) || is.na(secret))
      stop("Set APS_CLIENT_ID and APS_CLIENT_SECRET env vars before starting the MCP server.")
    .aps_token_cache$token <- getToken(
      id = id, secret = secret,
      scope = "data:read data:write code:all"
    )
  }
  .aps_token_cache$token
}

.mcp_result <- function(x) {
  list(content = x$content, path = x$path)
}

#' MCP tools for AutoDeskR
#'
#' Returns a named list of \code{ellmer::tool()} objects that expose
#' AutoDeskR functions to AI models via the Model Context Protocol (MCP).
#' Credentials are read from the \code{APS_CLIENT_ID} and
#' \code{APS_CLIENT_SECRET} environment variables; no token argument is
#' required in any tool call.
#'
#' @return A named list of \code{ellmer::tool} objects covering Authentication,
#'   Data Management, Model Derivative, Design Automation, and Reality Capture.
#' @export
#' @examples
#' \dontrun{
#' Sys.setenv(APS_CLIENT_ID = "your_id", APS_CLIENT_SECRET = "your_secret")
#' tools <- autodeskr_mcp_tools()
#' mcptools::mcp_server(tools = tools)
#' }
autodeskr_mcp_tools <- function() {
  if (!requireNamespace("ellmer", quietly = TRUE))
    stop("Package 'ellmer' is required. Install with: install.packages('ellmer')")

  list(

    # -------------------------------------------------------------------------
    # Authentication
    # -------------------------------------------------------------------------

    get_token = ellmer::tool(
      function() {
        .aps_token_cache$token <- NULL
        tok <- .aps_session_token()
        list(token_type = tok$token_type, expires_in = tok$expires_in)
      },
      name = "get_token",
      description = paste(
        "Obtain a fresh OAuth2 token from AutoDesk Platform Services using",
        "credentials stored in the APS_CLIENT_ID and APS_CLIENT_SECRET",
        "environment variables. Call this to explicitly refresh the session token."
      ),
      arguments = list()
    ),

    # -------------------------------------------------------------------------
    # Data Management
    # -------------------------------------------------------------------------

    make_bucket = ellmer::tool(
      function(bucket, policy = "transient") {
        .mcp_result(makeBucket(token = .aps_session_token(),
                               bucket = bucket, policy = policy))
      },
      name = "make_bucket",
      description = paste(
        "Create a new OSS cloud storage bucket in AutoDesk Platform Services.",
        "Returns the bucketKey, owner, and creation date."
      ),
      arguments = list(
        bucket = ellmer::type_string("Unique bucket name (lowercase letters, numbers, and hyphens only)."),
        policy = ellmer::type_string("Retention policy: 'transient' (24 h), 'temporary' (30 days), or 'persistent'.")
      )
    ),

    check_bucket = ellmer::tool(
      function(bucket) {
        .mcp_result(checkBucket(token = .aps_session_token(), bucket = bucket))
      },
      name = "check_bucket",
      description = "Check the details and status of an existing OSS bucket.",
      arguments = list(
        bucket = ellmer::type_string("Name of the bucket to check.")
      )
    ),

    list_buckets = ellmer::tool(
      function(limit = 10L, region = "US") {
        .mcp_result(listBuckets(token = .aps_session_token(),
                                limit = limit, region = region))
      },
      name = "list_buckets",
      description = "List all OSS buckets owned by this application.",
      arguments = list(
        limit  = ellmer::type_integer("Maximum number of buckets to return (default 10)."),
        region = ellmer::type_string("Region code: 'US' or 'EMEA'.")
      )
    ),

    upload_file = ellmer::tool(
      function(file, bucket) {
        .mcp_result(uploadFile(file = file, token = .aps_session_token(),
                               bucket = bucket))
      },
      name = "upload_file",
      description = paste(
        "Upload a local design file (DWG, RVT, IFC, etc.) to an OSS bucket.",
        "Returns the objectId (URN) needed for translation. Limited to ~100 MB;",
        "use upload_file_signed for larger files."
      ),
      arguments = list(
        file   = ellmer::type_string("Absolute path to the local file to upload."),
        bucket = ellmer::type_string("Target bucket name.")
      )
    ),

    list_objects = ellmer::tool(
      function(bucket, limit = 10L) {
        .mcp_result(listObjects(token = .aps_session_token(),
                                bucket = bucket, limit = limit))
      },
      name = "list_objects",
      description = "List objects (files) stored in an OSS bucket.",
      arguments = list(
        bucket = ellmer::type_string("Bucket name to list objects from."),
        limit  = ellmer::type_integer("Maximum number of objects to return (default 10).")
      )
    ),

    delete_object = ellmer::tool(
      function(bucket, object) {
        .mcp_result(deleteObject(token = .aps_session_token(),
                                 bucket = bucket, object = object))
      },
      name = "delete_object",
      description = "Delete an object from an OSS bucket.",
      arguments = list(
        bucket = ellmer::type_string("Bucket name containing the object."),
        object = ellmer::type_string("Object key (filename) to delete.")
      )
    ),

    # -------------------------------------------------------------------------
    # Model Derivative
    # -------------------------------------------------------------------------

    translate_svf = ellmer::tool(
      function(urn) {
        .mcp_result(translateSvf(urn = urn, token = .aps_session_token()))
      },
      name = "translate_svf",
      description = paste(
        "Translate a design file to SVF format for 2D/3D viewing.",
        "The urn must be Base64-encoded (apply base64 encoding to the objectId",
        "returned by upload_file). Poll status with check_file."
      ),
      arguments = list(
        urn = ellmer::type_string("Base64-encoded object URN from upload_file.")
      )
    ),

    translate_svf2 = ellmer::tool(
      function(urn, views = "2d,3d") {
        view_vec <- trimws(strsplit(views, ",")[[1]])
        .mcp_result(translateSvf2(urn = urn, token = .aps_session_token(),
                                  views = view_vec))
      },
      name = "translate_svf2",
      description = paste(
        "Translate a design file to SVF2 format (next-gen, ~30% smaller than SVF).",
        "The urn must be Base64-encoded. Poll status with check_file."
      ),
      arguments = list(
        urn   = ellmer::type_string("Base64-encoded object URN."),
        views = ellmer::type_string("Comma-separated view types to generate: '2d', '3d', or '2d,3d'.")
      )
    ),

    check_file = ellmer::tool(
      function(urn) {
        .mcp_result(checkFile(urn = urn, token = .aps_session_token()))
      },
      name = "check_file",
      description = paste(
        "Check the translation status of a design file.",
        "Returns status ('inprogress', 'success', or 'failed') and a progress percentage."
      ),
      arguments = list(
        urn = ellmer::type_string("Base64-encoded object URN.")
      )
    ),

    get_metadata = ellmer::tool(
      function(urn) {
        .mcp_result(getMetadata(urn = urn, token = .aps_session_token()))
      },
      name = "get_metadata",
      description = paste(
        "Retrieve metadata for a successfully translated design file.",
        "Returns view GUIDs required by get_data and get_object_tree."
      ),
      arguments = list(
        urn = ellmer::type_string("Base64-encoded object URN.")
      )
    ),

    get_data = ellmer::tool(
      function(guid, urn) {
        .mcp_result(getData(guid = guid, urn = urn, token = .aps_session_token()))
      },
      name = "get_data",
      description = paste(
        "Get geometric and property data for a model view.",
        "Requires a view GUID from get_metadata."
      ),
      arguments = list(
        guid = ellmer::type_string("View GUID from get_metadata."),
        urn  = ellmer::type_string("Base64-encoded object URN.")
      )
    ),

    get_object_tree = ellmer::tool(
      function(guid, urn) {
        .mcp_result(getObjectTree(guid = guid, urn = urn,
                                  token = .aps_session_token()))
      },
      name = "get_object_tree",
      description = paste(
        "Get the hierarchical object tree for a model view.",
        "Requires a view GUID from get_metadata."
      ),
      arguments = list(
        guid = ellmer::type_string("View GUID from get_metadata."),
        urn  = ellmer::type_string("Base64-encoded object URN.")
      )
    ),

    get_output_urn = ellmer::tool(
      function(urn) {
        .mcp_result(getOutputUrn(urn = urn, token = .aps_session_token()))
      },
      name = "get_output_urn",
      description = paste(
        "Get the URN of the translated output file from the manifest.",
        "The returned output_urn is needed by download_file."
      ),
      arguments = list(
        urn = ellmer::type_string("Base64-encoded source object URN.")
      )
    ),

    download_file = ellmer::tool(
      function(urn, output_urn, destfile) {
        .mcp_result(downloadFile(urn = urn, output_urn = output_urn,
                                 token = .aps_session_token(),
                                 destfile = destfile))
      },
      name = "download_file",
      description = paste(
        "Download a translated output file to a local path.",
        "Requires the output_urn from get_output_urn."
      ),
      arguments = list(
        urn        = ellmer::type_string("Base64-encoded source object URN."),
        output_urn = ellmer::type_string("Base64-encoded output URN from get_output_urn."),
        destfile   = ellmer::type_string("Absolute local file path for the downloaded file.")
      )
    ),

    # -------------------------------------------------------------------------
    # Design Automation
    # -------------------------------------------------------------------------

    make_pdf = ellmer::tool(
      function(source, destination) {
        .mcp_result(makePdf(source = source, destination = destination,
                            token = .aps_session_token()))
      },
      name = "make_pdf",
      description = paste(
        "Convert a DWG file to PDF using the Design Automation API.",
        "source and destination must be publicly accessible URLs.",
        "Returns a WorkItem ID; poll conversion status with check_pdf."
      ),
      arguments = list(
        source      = ellmer::type_string("Publicly accessible URL of the source DWG file."),
        destination = ellmer::type_string("Publicly accessible URL where the output PDF will be posted.")
      )
    ),

    check_pdf = ellmer::tool(
      function(id) {
        .mcp_result(checkPdf(id = id, token = .aps_session_token()))
      },
      name = "check_pdf",
      description = paste(
        "Check the status of a DWG-to-PDF conversion WorkItem.",
        "Status values: 'inprogress', 'pending', 'success', or 'failed'."
      ),
      arguments = list(
        id = ellmer::type_string("WorkItem ID returned by make_pdf.")
      )
    ),

    # -------------------------------------------------------------------------
    # Reality Capture
    # -------------------------------------------------------------------------

    create_photoscene = ellmer::tool(
      function(name, format = "rcm") {
        .mcp_result(createPhotoscene(name = name, format = format,
                                     token = .aps_session_token()))
      },
      name = "create_photoscene",
      description = paste(
        "Create a new photogrammetry scene for 3D capture from photographs.",
        "Returns a photoscene_id needed by upload_images and process_photoscene."
      ),
      arguments = list(
        name   = ellmer::type_string("Name for the photoscene."),
        format = ellmer::type_string("Output format: 'rcm', 'rcs', 'obj', 'ortho', or 'report'.")
      )
    ),

    upload_images = ellmer::tool(
      function(photoscene_id, files) {
        file_vec <- trimws(strsplit(files, ",")[[1]])
        .mcp_result(uploadImages(photoscene_id = photoscene_id,
                                 files = file_vec,
                                 token = .aps_session_token()))
      },
      name = "upload_images",
      description = paste(
        "Upload photographs to a photoscene for 3D reconstruction.",
        "Accepts JPEG or PNG files."
      ),
      arguments = list(
        photoscene_id = ellmer::type_string("Photoscene ID from create_photoscene."),
        files         = ellmer::type_string("Comma-separated absolute paths to local image files.")
      )
    ),

    process_photoscene = ellmer::tool(
      function(photoscene_id) {
        .mcp_result(processPhotoscene(photoscene_id = photoscene_id,
                                      token = .aps_session_token()))
      },
      name = "process_photoscene",
      description = paste(
        "Start photogrammetry processing on an uploaded image set.",
        "Poll progress with check_photoscene."
      ),
      arguments = list(
        photoscene_id = ellmer::type_string("Photoscene ID from create_photoscene.")
      )
    ),

    check_photoscene = ellmer::tool(
      function(photoscene_id) {
        .mcp_result(checkPhotoscene(photoscene_id = photoscene_id,
                                    token = .aps_session_token()))
      },
      name = "check_photoscene",
      description = paste(
        "Check the processing progress of a photoscene.",
        "Returns a progress percentage string and a status message."
      ),
      arguments = list(
        photoscene_id = ellmer::type_string("Photoscene ID from create_photoscene.")
      )
    )

  )
}
