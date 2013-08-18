'use strict'

# Construct a box directory from a connection it belongs to and API metadata
window.nimbus_app.box_directory = (connection, metadata) ->
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
      type: 'GET'
      url: 'https://api.box.com/2.0/folders/' + metadata.id + '/items'
      headers: Authorization: 'Bearer ' + connection.access_token()
      dataType: 'JSON'
      success: (data) ->
        resources = data.entries
        files = []
        subdirectories = []
        for file in resources.items
          if file.type == 'folder'
            subdirectories.push(nimbus_app.box_directory(connection, file, this))
          else
            constructed_file = nimbus_app.box_file(connection, file)
            files.push(constructed_file)
        isEnumerated = true
        promise.resolve()

  name = metadata.name

  # Re-enumerates the directory
  update = (promise) ->
    isEnumerated = false
    enumerate(promise)

  # Returns options object for jQuery File Upload
  upload = (filename, promise) ->
    file_found = false
    for file in files
      if file.full_name()
        file_found = file
        break
    if file_found
      url = 'https://upload.box.com/api/2.0/files/' + file.id() + '/content'
      form_data =
        filename: filename
    else
      url = 'https://upload.box.com/api/2.0/files/content'
      form_data =
        filename: filename
        parent_id: metadata.id
    url: url
    dataType: 'JSON'
    headers: Authorization: 'Bearer ' + connection.access_token()
    type: 'post'
    dropZone: null
    data:
      access_token: connection.access_token()
    formData: form_data
    success: (data) -> upload_callback(data, promise)

  upload_callback = (data, promise) ->
    file = data.entries[0]
    resources.push(file)
    files.push(nimbus_app.box_file(connection, file))
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
