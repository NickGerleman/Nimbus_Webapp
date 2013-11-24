'use strict'

# Construct a google directory from a connection it belongs to and API metadata
window.nimbus_app.google_directory = (connection, metadata) ->
  isEnumerated = false
  files = []
  subdirectories = []
  resources = []

  # Enumerate the directory
  enumerate = (promise) ->
    if isEnumerated
      promise.resolve()
      return
    $.ajax
      url: 'https://www.googleapis.com/drive/v2/files'
      data:
        access_token: connection.access_token()
        q: "trashed = false and '" + metadata.id + "' in parents"
      dataType: 'JSON'
      success: (data) ->
        resources = data.items
        files = []
        subdirectories = []
        for file in resources
          if file.mimeType == 'application/vnd.google-apps.folder'
            subdirectories.push(nimbus_app.google_directory(connection, file, this))
          else
            constructed_file = nimbus_app.google_file(connection, file)
            files.push(constructed_file)
        isEnumerated = true
        promise.resolve()
      error: -> promise.reject('Unable to recieve folder data from Google Drive API')

  name = metadata.title

  # Re-enumerates the directory
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
    error: -> promise.reject()

  upload_callback = (data, filename, promise) ->
    id = data.id
    $.ajax
      url: 'https://www.googleapis.com/drive/v2/files/' + id
      headers: Authorization: 'Bearer ' + connection.access_token()
      contentType: 'application/json'
      dataType: 'json'
      type: 'PATCH'
      data: JSON.stringify
        title: filename
        parents: [
          kind: 'drive#fileLink'
          id: metadata.id
        ]
      success: (data) ->
        resources.push(data)
        files.push(nimbus_app.google_file(connection, data))
        promise.resolve()
      error: -> promise.reject()


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