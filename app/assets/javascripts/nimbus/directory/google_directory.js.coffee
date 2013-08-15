window.nimbus_app.google_directory = (connection, metadata) ->
  that = nimbus_app.directory()
  isEnumerated = false
  files = []
  subdirectories = []

  enumerate = (promise) ->
    if isEnumerated
      promise.resolve()
      return

    $.getJSON 'https://www.googleapis.com/drive/v2/files',
      access_token: connection.access_token()
      q: "trashed = false and '" + metadata.id + "' in parents",
      (data) ->
        for file in data.items
          if file.mimeType == 'application/vnd.google-apps.folder'
            subdirectories.push(nimbus_app.google_directory(connection, file, this))
          else
            constructed_file = nimbus_app.google_file(connection, file)
            files.push(constructed_file)
        isEnumerated = true
        promise.resolve()

  update = (promise) ->
    isEnumerated = false
    enumerate(promise)

  # Returns options object for jQuery File Upload
  upload = -> (filename)
    #Todo

  name = metadata.title


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