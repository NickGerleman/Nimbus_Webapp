window.nimbus_app.dropbox_directory = (connection, metadata) ->
  that = nimbus_app.directory()
  isEnumerated = false
  files = []
  subdirectories = []

  if metadata.contents
    for file in metadata.contents
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
        for file in metadata.contents
          if file.is_dir
            subdirectories.push(nimbus_app.dropbox_directory(connection, file, this))
          else
            constructed_file = nimbus_app.dropbox_file(connection, file)
            files.push(constructed_file)
        isEnumerated = true
        promise.resolve()

  update = (promise) ->
    isEnumerated = false
    enumerate(promise)

  # Returns options object for jQuery File Upload
  upload = -> (filename)
    #Todo


  name = metadata.path.slice(metadata.path.lastIndexOf('/') + 1)


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