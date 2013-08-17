'use strict'

window.nimbus_app.metadirectory = (parent, directories) ->
  isEnumerated = false
  memo_path = null

  name = if !parent then '' else directories[0].name()

  # Creates a string representation of the path of the metadirectory
  path = ->
    memo_path or do ->
      paths = []
      current_directory = to_return
      while current_directory isnt null
        paths.unshift(current_directory.name())
        current_directory = current_directory.parent()
      paths = paths.map (path) -> '/' + path if path
      memo_path = paths.join('')

  # Enumerate the metadirectory
  enumerate = (promise) ->
    promises = []
    promises.push($.Deferred()) for directory in directories
    $.when.apply($, promises).then ->
      isEnumerated = true
      promise.resolve()
    directory.enumerate(promises.pop()) for directory in directories

  # Get the files in the metadirectory
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

  # Get the subdirectories(metadirectories) in the metadirectory
  subdirectories = ->
    subdirectories = []
    initial_directories = []
    for directory in directories
      for subdirectory in directory.subdirectories()
        initial_directories.push(subdirectory)
    return [] unless initial_directories[0]
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

  # Re-enumerates the directory
  update = (promise) ->
    isEnumerated = false
    enumerate(promise)

  to_return =
    # The directories(not metadirectories) that represent this metadirectory
    directories: -> directories
    # The name of the directory
    name: -> name
    # The parent metadirectory(null if current metadirectory is root)
    parent: -> parent
    # The path of the metadirectory
    enumerate: enumerate
    files: files
    path: path
    subdirectories: subdirectories
    update: update