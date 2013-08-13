window.nimbus_app.meta_directory = (parent, directories) ->
  isEnumerated = false

  name = directories[0].name()

  path = directories[0].path()

  files = ->
    files = []
    files = files.concat(d.files()) for d in directories

  subdirectories = ->
    subdirectories = []
    initial_directories = []
    initial_directories = initial_directories().concat(d.subdirectories()) for d in directories
    initial_directories.sort (a,b) ->
      switch
        when a.name < b.name then -1
        when a.name > b.name then 1
        else 0
    directory_buffer = []
    while subdirectories.length > 0
      directory = initial_directories.shift()
      if directory_buffer.length == 0 or directory_buffer[0].name == directory.name
        directory_buffer.push(directory)
      else
        subdirectories.push(nimbus_app.meta_directory(this, directory_buffer))
        directory_buffer = [directory]
    subdirectories.push(nimbus_app.meta_directory(this, directory_buffer))
    subdirectories


  enumerate = (promise) ->
    promises = []
    for directory in directories
      directory.enumerate(promises.push($.Deferred()))
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
  name: name
  directories: -> directories
  isEnumerated: -> isEnumerated