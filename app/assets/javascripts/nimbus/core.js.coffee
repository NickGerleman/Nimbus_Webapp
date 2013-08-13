window.nimbus_app.core = (socket_uri, refresh_callback) ->
  # put inside a second anonymous function so that changing instance variables are only visible to
  # those with direct reference to this
  do ->
    init_done = false
    @ui_callback = refresh_callback
    current_directory = null

    initialize = init_done or (promise) ->
      that = this
      user_retrieved = $.Deferred()
      connections_retrieved = $.Deferred()
      faye_connected = $.Deferred()
      directory_enumerated = $.Deferred()

      @user = nimbus_app.user(user_retrieved, this)
      @connections = nimbus_app.connections(connections_retrieved, this)

      user_retrieved.done ->
        that.faye = nimbus_app.faye(faye_connected, socket_uri, that)

      $.when(connections_retrieved, faye_connected).then ->
        directories = []
        promises = []
        for connection in @connections.all()
          promise = promises.push($.Deferred())
          promise.done (directory) -> directories.push(directory)
          create_directory(connection, '/', promise)
        $.when.apply($, promises).then ->
          current_directory = nimbus_app.meta_directory(null, directories)
          current_directory.enumerate(directory_enumerated)

      directory_enumerated.done -> promise.resolve()

    create_directory = (connection, path, promise) ->
      internal_promise = $.Deferred()
      switch connection.type
        when 'dropbox'
          internal_promise.done (data) ->
            promise.resolve(nimbus_app.dropbox_directory(connection, data))
          $.getJSON 'https://api.dropbox.com/1/metadata/dropbox' + path,
            access_token: connection.access_token,
            (data) -> internal_promise.resolve(data)
        when 'google'
          ->
        when 'box'
          ->
        when 'skydrive'
          ->
        else console.log('unknown service')

    change_directory = (directory, promise) ->
      internal_promise = $.Deferred()
      directory.enumerate(internal_promise)
      internal_promise.done ->
        current_directory = directory
        promise.resolve()


    user: -> that.user
    connections: -> that.connections
    faye: -> that.faye
    initialize: initialize
    current_directory: -> current_directory
    change_directory: change_directory

