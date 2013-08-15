window.nimbus_app.core = (socket_uri, refresh_callback) ->
  # put inside a second anonymous function so that changing instance variables are only visible to
  # those with direct reference to this
  do ->

    faye = null
    connections_manager = null
    current_directory = null
    user = null

    add_connection = (connection) ->
      connections_manager.add(connection)
      promise = $.Deferred()
      promise.done -> refresh_callback()
      rebuild_directories(promise)

    change_directory = (directory, promise) ->
      internal_promise = $.Deferred()
      directory.enumerate(internal_promise)
      internal_promise.done ->
        current_directory = directory
        promise.resolve()

    create_root_metadirectory = (promise) ->
      directories = []
      promises = []
      for id, connection of connections_manager.all()
        internal_promise = $.Deferred()
        internal_promise.done (directory) -> directories.push(directory)
        promises.push(internal_promise)
        connection.create_root_directory(internal_promise)
      $.when.apply($, promises).then ->
        metadirectory = nimbus_app.metadirectory(null, directories)
        promise.resolve(metadirectory)

    # Rebuilds all directories until it reaches the path of the current directory, it then replaces
    # current_directory
    rebuild_directories = (promise) ->
      paths = current_directory.split('/')
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
          directory.enumerate(directory_enumerated)

    remove_connection = (id) ->
      connections_manager.remove(id)
      promise = $.Deferred()
      promise.done -> refresh_callback()
      rebuild_directories(promise)

    update_connection = (connection) ->
      if connections_manager.get(connection.id)
        connections_manager.update(connection)
      else
        add_connection(connection)

    # initialize the application and enumerate the current directory
    #
    # @param promise a Deffered that is resolved after initialization is done
    initialize = (promise) ->
      user_retrieved = $.Deferred()
      connections_retrieved = $.Deferred()
      root_created = $.Deferred()
      directory_enumerated = $.Deferred()

      user = nimbus_app.user(user_retrieved)
      connections_manager = nimbus_app.connections_manager(connections_retrieved)

      user_retrieved.done ->
        faye = nimbus_app.faye
          socket_uri: socket_uri
          socket_token: user.socket_token()
          user_id: user.id()
          update_callback: update_connection
          remove_callback: remove_connection

      connections_retrieved.done ->
        create_root_metadirectory(root_created)

      root_created.done (root) ->
        current_directory = root
        root.enumerate(directory_enumerated)

      directory_enumerated.done -> promise.resolve()


    current_directory: -> current_directory
    user: -> user
    change_directory: change_directory
    initialize: initialize
