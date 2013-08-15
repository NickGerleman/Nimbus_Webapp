window.nimbus_app.skydrive_directory = (connection, metadata) ->
  that = nimbus_app.directory()
  isEnumerated = false
  files = []
  subdirectories = []
  resources = []

  if metadata.data
    resources = metadata.data
    for file in resources
      if file.is_dir
        subdirectories.push(nimbus_app.skydrive_directory(connection, file, this))
      else
        constructed_file = nimbus_app.skydrive_file(connection, file)
        files.push(constructed_file)
    isEnumerated = true


  enumerate = (promise) ->
    if isEnumerated
      promise.resolve()
      return
    params = {access_token: connection.access_token()}
    params.hash = metadata.hash if isEnumerated

    $.getJSON 'https://apis.live.net/v5.0/' + metadata.id + '/files',
      params,
      (data) ->
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

  name = metadata.name

  update = (promise) ->
    isEnumerated = false
    enumerate(promise)

  # Returns options object for jQuery File Upload
  upload = (filename, promise) ->
    url: 'https://apis.live.net/v5.0/' + metadata.id + '/files/' + filename
    type: 'put'
    multipart: false
    dropZone: null
    data:
      access_token: connection.access_token()
    success: (data) -> upload_callback(data, promise)

  upload_callback = (data, promise) ->
    id = data.id
    $.getJSON metadata.upload_location,
      access_token: connection.access_token(),
      (data) ->
        resources.push(data)
        files.push(nimbus_app.skydrive_file(data))
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