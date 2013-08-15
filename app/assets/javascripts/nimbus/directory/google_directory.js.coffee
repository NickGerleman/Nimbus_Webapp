window.nimbus_app.google_directory = (connection, metadata) ->
  that = nimbus_app.directory()
  isEnumerated = false
  files = []
  subdirectories = []
  resources = []

  enumerate = (promise) ->
    if isEnumerated
      promise.resolve()
      return

    $.getJSON 'https://www.googleapis.com/drive/v2/files',
      access_token: connection.access_token()
      q: "trashed = false and '" + metadata.id + "' in parents",
      (data) ->
        resources = data
        files = []
        subdirectories = []
        for file in resources.items
          if file.mimeType == 'application/vnd.google-apps.folder'
            subdirectories.push(nimbus_app.google_directory(connection, file, this))
          else
            constructed_file = nimbus_app.google_file(connection, file)
            files.push(constructed_file)
        isEnumerated = true
        promise.resolve()

  name = metadata.title

  update = (promise) ->
    isEnumerated = false
    enumerate(promise)

  # Returns options object for jQuery File Upload
  upload = (filename, promise) ->
    url: 'https://www.googleapis.com/upload/drive/v2/files'
    type: 'put'
    multipart: false
    dropZone: null
    data:
      access_token: connection.access_token()
      uploadType: 'media'
    success: (data) -> upload_callback(data, filename, promise)

  upload_callback = (data, filename, promise) ->
    id = data.id
    $.ajax
      url: 'https://www.googleapis.com/drive/v2/files/' + id
      dataType: 'json'
      type: 'PATCH'
      data:
        title: filename
        parents: [
          kind: 'drive#fileLink'
          id: metadata.id
        ]
      success: (data) ->
        resources.push(data)
        files.push(nimbus_app.google_file(connection, data))
        promise.resolve()


  that.connection = -> connection
  that.files = -> files
  that.isEnumerated = -> isEnumerated
  that.mime_type = -> metadata.mimeType
  that.name = -> name
  that.subdirectories = -> subdirectories
  that.enumerate = enumerate
  that.update = update
  that.upload = upload
  that