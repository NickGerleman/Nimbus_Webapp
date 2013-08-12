window.nimbus_app.meta_directory = (parent, directories) ->
  files = []
  subdirectories = []
  isEnumerated = false

  path = directories[0].path

  get_files = ->
    files = []
    files = files.concat(d.files) for d in directories

  get_subdirectories = ->
    initial_directories = []
    subdirectories = []
    initial_directories = initial_directories().concat(d.subdirectories) for d in directories
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
      files = get_files()
      subdirectories = get_subdirectories()
      isEnumerated = true
      promise.resolve()

  enumerate: enumerate
  subdirectories: subdirectories
  parent: parent
  files: files
  path: path
  isEnumerated: -> isEnumerated