window.nimbus_app.dropbox_directory = (connection, metadata) ->
  that = nimbus_app.directory()
  isEnumerated = false
  files = []
  subdirectories = []
  resources = []

  if metadata.contents
    resources = metadata.contents
    for file in resources
      if file.is_dir
        subdirectories.push(nimbus_app.dropbox_directory(connection, file, this))
      else
        constructed_file = nimbus_app.dropbox_file(connection, file)
        files.push(constructed_file)
    isEnumerated = true


  enumerate = (promise) ->
    if isEnumerated
      promise.resolve()
      return
    params = {access_token: connection.access_token()}
    params.hash = metadata.hash if isEnumerated

    $.getJSON 'https://api.dropbox.com/1/metadata/dropbox' + metadata.path,
      params,
      (data) ->
        metadata = data
        resources = metadata.contents
        files = []
        subdirectories = []
        for file in resources
          if file.is_dir
            subdirectories.push(nimbus_app.dropbox_directory(connection, file, this))
          else
            constructed_file = nimbus_app.dropbox_file(connection, file)
            files.push(constructed_file)
        isEnumerated = true
        promise.resolve()

  name = metadata.path.slice(metadata.path.lastIndexOf('/') + 1)

  update = (promise) ->
    isEnumerated = false
    enumerate(promise)

  # Returns options object for jQuery File Upload
  upload = (filename, promise) ->
    url: 'https://api-content.dropbox.com/1/files_put/dropbox' + metadata.path + '/' + filename
    type: 'put'
    multipart: false
    dropZone: null
    data:
      access_token: connection.access_token()
    success: (data) -> upload_callback(data, promise)

  upload_callback = (data, promise) ->
    resources.push(data)
    files.push(nimbus_app.dropbox_file(connection, data))
    promise.resolve()


  that.connection = -> connection
  that.files = -> files
  that.isEnumerated = -> isEnumerated
  that.name = -> name
  that.path = -> metadata.path
  that.subdirectories = -> subdirectories
  that.enumerate = enumerate
  that.update = update
  that.upload = upload
  that