window.nimbus_app.core = (socket_uri, refresh_callback) ->
  # put inside a second anonymous function so that changing instance variables are only visible to
  # those with direct reference to this
  do ->
    init_done = false
    ui_callback = refresh_callback
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
        #enumerate initial directory

      directory_enumerated.done -> promise.resolve()

    change_directory = (id) ->


    user: -> that.user
    connections: -> that.connections
    faye: -> that.faye
    initialize: initialize
    current_directory: current_directory
    change_directory: change_directory

