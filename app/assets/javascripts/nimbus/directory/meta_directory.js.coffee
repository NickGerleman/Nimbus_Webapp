window.nimbus_app.meta_directory = (parent, directories) ->
  isEnumerated = false

  name = directories[0].name()

  path = directories[0].path()

  files = ->
    files = []
    for directory in directories
      for file in directory.files()
        files.push(file)
    files

  subdirectories = ->
    subdirectories = []
    initial_directories = []
    for directory in directories
      for subdirectory in directory.subdirectories()
        initial_directories.push(subdirectory)
    initial_directories.sort (a,b) ->
      switch
        when a.name().toLowerCase() < b.name().toLowerCase() then -1
        when a.name().toLowerCase() > b.name().toLowerCase() then 1
        else 0
    directory_buffer = []
    while initial_directories.length > 0
      directory = initial_directories.shift()
      if directory_buffer.length == 0 or directory_buffer[0].name() == directory.name
        directory_buffer.push(directory)
      else
        subdirectories.push(nimbus_app.meta_directory(this, directory_buffer))
        directory_buffer = [directory]
    subdirectories.push(nimbus_app.meta_directory(this, directory_buffer))
    subdirectories


  enumerate = (promise) ->
    promises = []
    for directory in directories
      internal_promise = $.Deferred()
      promises.push internal_promise
      directory.enumerate(internal_promise)
    $.when.apply($, promises).then ->
      isEnumerated = true
      promise.resolve()

  remove_connection = (connection) ->
    directories = directories.filter (directory) -> directory.connection() != connection
    core.ui_callback()

  add_directory = (directory) ->
    promise = $.Deferred()
    promise.done ->
      directories.push(directory)
      core.ui_callback()
    directory.enumerate(promise)


  remove_connection: remove_connection
  add_directory: add_directory
  enumerate: if isEnumerated then (promise) -> promise.resolve() else enumerate
  update: enumerate
  subdirectories: subdirectories
  parent: -> parent
  files: files
  path: -> path
  name: -> name
  directories: -> directories
  isEnumerated: -> isEnumerated