'use strict'

# Construct a box directory from a connection it belongs to and API metadata
window.NimbusApp.BoxDirectory = (connection, metadata) ->
  isEnumerated = false
  files = []
  subdirectories = []
  resources = []

  # Delete the directory
  destroy = (promise) ->
    $.ajax
      type: 'DELETE'
      url: 'https://api.box.com/2.0/folders/' + metadata.id + '?recursive=true&access_token=' + connection.access_token()
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
    $.ajax
      url: 'https://api.box.com/2.0/folders/' + metadata.id + '/items'
      data:
        access_token: connection.access_token()
        fields: 'name,id,modified_at,size'
      dataType: 'JSON'
      success: (data) ->
        resources = data.entries
        files = []
        subdirectories = []
        for file in resources
          if file.type == 'folder'
            subdirectories.push(NimbusApp.BoxDirectory(connection, file, this))
          else
            constructed_file = NimbusApp.BoxFile(connection, file)
            files.push(constructed_file)
        isEnumerated = true
        promise.resolve()
      error: (jqXHR, textStatus, errorThrown) ->
        promise.reject('Unable to recieve folder data from Box API:' + errorThrown)

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
    type: 'post'
    dropZone: null
    data:
      access_token: connection.access_token()
    formData: form_data
    success: (data) -> upload_callback(data, promise)
    error: (jqXHR, textStatus, errorThrown) ->
      promise.reject('Unable to upload file:' + errorThrown)

  upload_callback = (data, promise) ->
    file = data.entries[0]
    resources.push(file)
    files.push(NimbusApp.BoxFile(connection, file))
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
