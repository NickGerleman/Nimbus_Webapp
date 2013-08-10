window.nimbus_app = (socket_uri) ->

  user = do ->
    user_info = undefined
    $.ajax
      url: '/api/user',
      dataType: "json",
      async: false,
      success: (data) -> user_info = data

    name = user_info.name
    id = user_info.id
    socket_token = user_info.socket_token

    {name: name, id: id, socket_token: socket_token}


  connections = do ->
    connections_array = undefined
    $.getJSON('/api/user/connections',(data) -> connections_array = data)

    all = -> connections_array.slice(0)

    get = (id) ->
      for connection in connections_array
        return connection if connection.id == id
      return null

    remove = (id) ->
      for connection, i in connections_array
        if connection.id == id
          connections_array.splice(i, 1)
          return

    update = (connection) ->
      delete(conenction.id)
      connections_array.push(connection)

    {all: all, get: get, remove: remove, update: update}


  faye = do ->
    callback_handler = (message) ->
      alert message
    client = new Faye.Client(socket_uri, {timeout: 120})
    client.addExtension
      outgoing: (message, callback) ->
        message.ext ||= {}
        message.ext.auth_token = user.socket_token
        callback(message)
    subscription = client.subscribe('/' + user.id, callback_handler)
    client

  {user: user, connections: connections, faye: faye}

