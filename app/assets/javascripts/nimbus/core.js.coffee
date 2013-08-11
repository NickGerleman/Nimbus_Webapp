window.nimbus_app.core = (socket_uri) ->
  # put inside a second anonymous function so that changing instance variables are only visible to
  # those with direct reference to this
  do ->
    that = this
    user_retrieved = $.Deferred()
    @user = nimbus_app.user(user_retrieved, this)
    connections_retrieved = $.Deferred()
    @connections = nimbus_app.connections(connections_retrieved, this)
    faye_connected = $.Deferred()
    directory_retrieved = $.Deferred()

    user_retrieved.done ->
      @faye = nimbus_app.faye(faye_connected, socket_uri, that)

    connections_retrieved.done ->
      @directory = nimbus_app.directory(directory_retrieved, that)

    user: -> that.user
    connections: -> that.connections
    faye: -> that.faye
    directory: -> that.directory
