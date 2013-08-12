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
    for connection, i in connections_array
      if connection.id == new_connection.id
        connections_array[i] = new_connection
        return
    new_connection.prototype = connection
    connections_array.push(new_connection)

  {all: all, get: get, remove: remove, update: update}