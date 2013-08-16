window.nimbus_app.metadirectory = (parent, directories) ->
  isEnumerated = false

  name = directories[0].name()

  path = directories[0].path()

  enumerate = (promise) ->
    promises = []
    for directory in directories
      internal_promise = $.Deferred()
      promises.push internal_promise
      directory.enumerate(internal_promise)
    $.when.apply($, promises).then ->
      isEnumerated = true
      promise.resolve()

  files = ->
    files = []
    for directory in directories
      for file in directory.files()
        files.push(file)
    files.sort (a,b) ->
      switch
        when a.full_name().toLowerCase() < b.full_name().toLowerCase() then -1
        when a.full_name().toLowerCase() > b.full_name().toLowerCase() then 1
        else 0
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
        subdirectories.push(nimbus_app.metadirectory(this, directory_buffer))
        directory_buffer = [directory]
    subdirectories.push(nimbus_app.metadirectory(this, directory_buffer))
    subdirectories

  update = (promise) ->
    isEnumerated = false
    enumerate(promise)


  directories: -> directories
  isEnumerated: -> isEnumerated
  name: -> name
  parent: -> parent
  path: -> path
  enumerate: enumerate
  files: files
  subdirectories: subdirectories
  update: update