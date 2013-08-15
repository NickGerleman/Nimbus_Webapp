window.nimbus_app.box_directory = (connection, metadata) ->
  that = nimbus_app.directory()
  isEnumerated = false
  files = []
  subdirectories = []
  resources = []

  enumerate = (promise) ->
    if isEnumerated
      promise.resolve()
      return

    $.ajax
      url: 'https://api.box.com/2.0/folders/' + metadata.id + '/items'
      data:
        access_token: connection.access_token()
      dataType: 'jsonp'
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

  update = (promise) ->
    isEnumerated = false
    enumerate(promise)

  # Returns options object for jQuery File Upload
  upload = (filename, promise) ->
    url: 'https://upload.box.com/api/2.0/files/content'
    type: 'post'
    dropZone: null
    data:
      access_token: connection.access_token()
    formData:
      filename: filename
      parent_id: metadata.id
    success: (data) -> upload_callback(data, promise)

  upload_callback = (data, promise) ->
    file = data.entries[0]
    resources.push(file)
    files.push(nimbus_app.box_file(connection, file))
    promise.resolve()


  that.connection = -> connection
  that.files = -> files
  that.isEnumerated = -> isEnumerated
  that.name = -> name
  that.subdirectories = -> subdirectories
  that.enumerate = enumerate
  that.update = update
  that.upload = upload
  that