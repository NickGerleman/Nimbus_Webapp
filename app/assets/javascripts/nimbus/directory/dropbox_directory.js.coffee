'use strict'

# Construct a dropbox directory from a connection it belongs to and API metadata
window.nimbus_app.dropbox_directory = (connection, metadata) ->
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


  # Enumerate the directory
  enumerate = (promise) ->
    if isEnumerated
      promise.resolve()
      return
    params = {access_token: connection.access_token()}
    params.hash = metadata.hash if isEnumerated
    $.ajax
      url: 'https://api.dropbox.com/1/metadata/dropbox' + metadata.path
      data: params
      dataType: 'JSON'
      success: (data) ->
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
      error: -> promise.reject('Unable to recieve folder data from Dropbox API')

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
    error: -> promise.reject()

  upload_callback = (data, promise) ->
    resources.push(data)
    files.push(nimbus_app.dropbox_file(connection, data))
    promise.resolve()


  # The connection the directory belongs to
  connection: -> connection
  # Array of files in the directory
  files: -> files
  # The name of the directory
  name: -> name
  # Array of subdirectories in the directory
  subdirectories: -> subdirectories
  enumerate: enumerate
  update: update
  upload: upload