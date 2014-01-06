'use strict'

window.NimbusApp.Core = (socket_uri, refresh_callback) ->
  # put inside a second anonymous function so that changing instance variables are only visible to
  # those with direct reference to this
  do ->

    faye = null
    connections_manager = null
    contains_expired = false
    current_directory = null
    user = null

    # Adds a new connection, rebuilds the directories to incorporate it, calls a UI refresh
    add_connection = (connection) ->
      connections_manager.add(connection)
      promise = $.Deferred()
      promise.done -> refresh_callback()
      rebuild_directories(promise)

    # Change the current directory to a different metadirectory, enumerates it
    change_directory = (directory, promise) ->
      internal_promise = $.Deferred()
      internal_promise.fail -> promise.reject()
      internal_promise.done ->
        current_directory = directory
        promise.resolve()
      directory.enumerate(internal_promise)

    # Creates and enumerates a root metadirectory using the connections in connections_manager
    # Returns the metadirectory in the promise
    create_root_metadirectory = (promise) ->
      directories = []
      promises = []
      promises.push($.Deferred()) for connection in connections_manager.all()
      $.when.apply($, promises).done ->
        metadirectory = NimbusApp.MetaDirectory(null, directories)
        promise.resolve(metadirectory)
      for connection in connections_manager.all()
        internal_promise = $.Deferred()
        internal_promise.fail (error) -> promise.reject(error)
        internal_promise.done (directory) ->
          enumerated_promise = $.Deferred()
          enumerated_promise.fail (error) -> promise.reject(error)
          enumerated_promise.done ->
            directories.push(directory)
            promises.pop().resolve()
          directory.enumerate(enumerated_promise)
        connection.create_root_directory(internal_promise)

    # Enumerates and returns the metadirectory corresponding to a given path in the promise
    get_directory = (name, promise) ->
      directory = current_directory
      while directory.parent()
        directory = directory.parent()
      path = name.split('/')
      #remove root directory
      path.shift()
      while path.length > 0
        dir_found = false
        dir_name = path.shift()
        for dir in directory.subdirectories()
          if dir.name() == dir_name
            dir_found = true
            directory = dir
            internal_promise = $.Deferred()
            internal_promise.fail (reason) -> promise.reject(reason)
            dir.enumerate(internal_promise)
        unless dir_found
          promise.reject("Unable to find directory " + dir_name)
          return
      internal_promise = $.Deferred()
      internal_promise.fail (reason) -> promise.reject(reason)
      internal_promise.done -> promise.resolve(directory)
      directory.enumerate(internal_promise)

    # Rebuilds all directories until it reaches the path of the current directory, it then replaces
    # current_directory
    rebuild_directories = (promise) ->
      paths = current_directory.path().split('/')
      directory = null
      do ->
        if paths.length == 0
          current_directory = directory
          promise.resolve()
          return
        directory_enumerated = $.Deferred()
        directory_enumerated.fail -> promise.reject()
        directory_enumerated.done ->
          this()
        path = paths.shift()
        if directory
          for subdirectory in directory.subdirectories()
            if subdirectory.name() == path
              directory = subdirectory
              break
          directory.enumerate(directory_enumerated)
        else
          root_created = $.Deferred()
          root_created.done (root) ->
            directory = root
            directory_enumerated.resolve()
          root_created.fail -> promise.reject()

    # Removes the connection with the specified, rebuilds directories, calls UI refresh
    remove_connection = (id) ->
      connections_manager.remove(id)
      promise = $.Deferred()
      promise.done -> refresh_callback()
      rebuild_directories(promise)

    # Handles connection_update message, will update connection or call for an add if appropriate
    update_connection = (connection) ->
      if connections_manager.get(connection.id)
        connections_manager.update(connection)
      else
        add_connection(connection)

    # Initializes the application and enumerates the current directory
    initialize = (promise, initial_directory) ->
      user_retrieved = $.Deferred()
      connections_retrieved = $.Deferred()
      connections_retrieved.fail -> (error) promise.reject(error)
      root_created = $.Deferred()
      root_created.fail (error) -> promise.reject(error)

      connections_retrieved.done ->
        contains_expired = connections_manager.contains_expired()
        create_root_metadirectory(root_created)

      root_created.done (root) ->
        current_directory = root

        if initial_directory
          internal_promise = $.Deferred()
          internal_promise.fail (reason) -> promise.reject(reason)
          internal_promise.done (dir) ->
            current_directory = dir
            promise.resolve()
          get_directory(initial_directory, internal_promise)
        else
          promise.resolve()
        user = NimbusApp.User(user_retrieved)
        user_retrieved.done ->
          faye_loaded = $.Deferred()
          faye_loaded.done (client) -> faye = client
          NimbusApp.FayeClient
            socket_uri: socket_uri
            socket_token: user.socket_token()
            user_id: user.id()
            update_callback: update_connection
            remove_callback: remove_connection
            promise: faye_loaded

      connections_manager = NimbusApp.ConnectionManager(connections_retrieved)


    # whether there are expired connections
    contains_expired: -> contains_expired
    # the current metadirectory
    current_directory: -> current_directory
    change_directory: change_directory
    get_directory: get_directory
    initialize: initialize
