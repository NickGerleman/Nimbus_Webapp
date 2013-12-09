'use strict'

# Construct a dropbox directory from a connection it belongs to and API metadata
window.NimbusApp.DropboxDirectory = (connection, metadata) ->
  isEnumerated = false
  files = []
  subdirectories = []
  resources = []

  if metadata.contents
    resources = metadata.contents
    for file in resources
      if file.is_dir
        subdirectories.push(NimbusApp.DropboxDirectory(connection, file, this))
      else
        constructed_file = NimbusApp.DropboxFile(connection, file)
        files.push(constructed_file)
    isEnumerated = true

  # Delete the directory
  destroy = (promise) ->
    $.ajax
      type: 'POST'
      url: 'https://api.dropbox.com/1/fileops/delete'
      data:
        root: 'dropbox'
        path: metadata.path
        access_token: connection.access_token()
      dataType: 'JSON'
      success: ->
        promise.resolve()
      error: (jqXHR, textStatus, errorThrown) ->
        promise.reject('Unable to delete folder for' + connection.name() + ': ' + errorThrown)

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
            subdirectories.push(NimbusApp.DropboxDirectory(connection, file, this))
          else
            constructed_file = NimbusApp.DropboxFile(connection, file)
            files.push(constructed_file)
        isEnumerated = true
        promise.resolve()
      error: (jqXHR, textStatus, errorThrown) ->
        promise.reject('Unable to recieve folder data from Dropbox API:' + errorThrown)

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
    error: (jqXHR, textStatus, errorThrown) ->
      promise.reject('Unable to upload file:' + errorThrown)

  upload_callback = (data, promise) ->
    resources.push(data)
    files.push(NimbusApp.DropboxFile(connection, data))
    promise.resolve()


  # The connection the directory belongs to
  connection: -> connection
  # Array of files in the directory
  files: -> files
  # The name of the directory
  name: -> name
  # Array of subdirectories in the directory
  subdirectories: -> subdirectories
  destroy: destroy
  enumerate: enumerate
  update: update
  upload: upload