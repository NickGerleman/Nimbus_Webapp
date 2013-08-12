window.nimbus_app.connections = (promise, core) ->

  connections_array = null
  $.getJSON '/api/user/connections',(data) ->
    connections_array = data
    promise.resolve()


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

  update = (new_connection) ->
    for connection in connections_array
      if connection.id == new_connection.id
        connection.name = new_connection.name
        connection.access_token = new_connection.access_token
        connection.last_updated = new_connection.last_updated
        return
    connections_array.push(new_connection)

  {all: all, get: get, remove: remove, update: update}