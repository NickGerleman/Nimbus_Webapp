window.nimbus_app.google_directory = (connection, metadata) ->
  that = nimbus_app.directory()
  isEnumerated = false
  children = []
  files = []
  subdirectories = []
  resources = []

  enumerate = (promise) ->
    if isEnumerated
      promise.resolve()
      return
    children_retrieved = $.Deferred()
    resources_retrieved = $.Deferred()

    $.getJSON 'https://www.googleapis.com/drive/v2/files/' + metadata.id + '/children',
      access_token: connection.access_token()
      folderId: metadata.id,
      (data) ->
        children = data.items
        children_retrieved.resolve()

    children_retrieved.done ->
      promises = []
      promises.push($.Deferred()) for child in children
      $.when.apply($, promises).then ->
        resources_retrieved.resolve()
      for child in children
        do ->
          $.getJSON 'https://www.googleapis.com/drive/v2/files/' + child.id,
            access_token: connection.access_token(),
            (data) ->
              resources.push(data)
              promises.pop().resolve()

    resources_retrieved.done ->
      for file in resources
        if file.mimeType == 'application/vnd.google-apps.folder'
          subdirectories.push(nimbus_app.google_directory(connection, file, this))
        else
          constructed_file = nimbus_app.google_file(connection, file)
          files.push(constructed_file)
      isEnumerated = true
      promise.resolve()

  update = (promise) ->
    isEnumerated = false
    enumerate(promise)

  # Returns options object for jQuery File Upload
  upload = -> (filename)
    #Todo


  name = metadata.title


  that.connection = -> connection
  that.files = -> files
  that.isEnumerated = -> isEnumerated
  that.mime_type = -> metadata.mimeType
  that.name = -> name
  that.subdirectories = -> subdirectories
  that.enumerate = enumerate
  that.update = update
  that.upload = upload
  that