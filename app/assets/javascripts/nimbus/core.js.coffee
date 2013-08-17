'use strict'

window.nimbus_app.core = (socket_uri, refresh_callback) ->
  # put inside a second anonymous function so that changing instance variables are only visible to
  # those with direct reference to this
  do ->

    faye = null
    connections_manager = null
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
      $.when.apply($, promises).then ->
        metadirectory = nimbus_app.metadirectory(null, directories)
        promise.resolve(metadirectory)
      for connection in connections_manager.all()
        internal_promise = $.Deferred()
        internal_promise.done (directory) ->
          enumerated_promise = $.Deferred()
          enumerated_promise.done ->
            directories.push(directory)
            promises.pop().resolve()
          directory.enumerate(enumerated_promise)
        connection.create_root_directory(internal_promise)

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
    initialize = (promise) ->
      user_retrieved = $.Deferred()
      connections_retrieved = $.Deferred()
      root_created = $.Deferred()

      connections_retrieved.done ->
        create_root_metadirectory(root_created)

      root_created.done (root) ->
        current_directory = root
        promise.resolve()
        user = nimbus_app.user(user_retrieved)
        user_retrieved.done ->
          faye_loaded = $.Deferred()
          faye_loaded.done (client) -> faye = client
          nimbus_app.faye
            socket_uri: socket_uri
            socket_token: user.socket_token()
            user_id: user.id()
            update_callback: update_connection
            remove_callback: remove_connection
            promise: faye_loaded

      connections_manager = nimbus_app.connections_manager(connections_retrieved)


    # the current metadirectory
    current_directory: -> current_directory
    change_directory: change_directory
    initialize: initialize
