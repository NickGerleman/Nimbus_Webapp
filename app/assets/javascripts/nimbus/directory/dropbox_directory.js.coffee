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
    params = {access_token: connection.access_token}
    params.hash = metadata.hash if isEnumerated
    metadata_retrieved = $.Deferred()
    $.getJSON 'https://api.dropbox.com/1/metadata/dropbox' + metadata.path,
      params,
      (data) ->
        metadata = data
        metadata_retrieved.resolve()
    metadata_retrieved.done ->
      for file in metadata.contents
        if file.is_dir
          subdirectories.push(nimbus_app.dropbox_directory(connection, file, this))
        else
          constructed_file = nimbus_app.dropbox_file(connection, file)
          files.push(constructed_file)
      isEnumerated = true
      promise.resolve()

  # Returns options object for jQuery File Upload
  upload =
    url: 'https://api-content.dropbox.com/1/files_put/dropbox' + metadata.path
    type: 'put'
    dropZone: null
    data:
      access_token: connection.access_token


  name = metadata.path.slice(metadata.path.lastIndexOf('/') + 1)

  that.path = -> metadata.path
  that.files = -> files
  that.subdirectories = -> subdirectories
  that.enumerate = enumerate
  that.update = enumerate
  that.upload = upload
  that.name = -> name
  that.connection = -> connection
  that.isEnumerated = -> isEnumerated
  that