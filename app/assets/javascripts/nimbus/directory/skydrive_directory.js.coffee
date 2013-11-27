'use strict'

# Construct a skydrive directory from a connection it belongs to and API metadata
window.nimbus_app.skydrive_directory = (connection, metadata) ->
  isEnumerated = false
  files = []
  subdirectories = []
  resources = []
  id = null

  if metadata.data
    resources = metadata.data
    for file in resources
      if file.is_dir
        subdirectories.push(nimbus_app.skydrive_directory(connection, file, this))
      else
        constructed_file = nimbus_app.skydrive_file(connection, file)
        files.push(constructed_file)
    isEnumerated = true

  # Enumerate the directory
  enumerate = (promise) ->
    if isEnumerated
      promise.resolve()
      return
    $.ajax
      url: 'https://apis.live.net/v5.0/' + (metadata.id || 'me') + '/skydrive/files'
      data: access_token: connection.access_token()
      dataType: 'JSON'
      success: (data) ->
        metadata = data
        resources = metadata.data
        files = []
        subdirectories = []
        for file in resources
          if file.is_dir
            subdirectories.push(nimbus_app.skydrive_directory(connection, file, this))
          else
            constructed_file = nimbus_app.skydrive_file(connection, file)
            files.push(constructed_file)
        isEnumerated = true
        promise.resolve()
      error: (jqXHR, textStatus, errorThrown) ->
        promise.reject('Unable to recieve folder data from SkyDrive API:' + errorThrown)

  name = metadata.name

  # Re-enumerates the directory
  update = (promise) ->
    isEnumerated = false
    enumerate(promise)

  # Returns options object for jQuery File Upload
  upload = (filename, promise) ->
    url: metadata.upload_location + filename
    type: 'put'
    multipart: false
    dropZone: null
    data: access_token: connection.access_token()
    success: (data) -> upload_callback(data, promise)
    error: (jqXHR, textStatus, errorThrown) ->
      promise.reject('Unable to upload file:' + errorThrown)

  upload_callback = (data, promise) ->
    id = data.id
    $.ajax
      url: 'https://apis.live.net/v5.0/' + id
      data: access_token: connection.access_token()
      dataType: 'JSON'
      success: (data) ->
        resources.push(data)
        files.push(nimbus_app.skydrive_file(data))
        promise.resolve()
      error: (jqXHR, textStatus, errorThrown) ->
        promise.reject('Unable to finalize file upload:' + errorThrown)


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