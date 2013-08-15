# Initializes a connections manager
#
# @param a Deffered that is resolved once connections are retrieved
# @returns the connection Manager
window.nimbus_app.connections_manager = (promise) ->

  connections = {}

  $.getJSON '/api/user/connections',(data) ->
    add(connection) for connection in data
    promise.resolve()

  add = (connection) ->
    id = connection.id
    new_connection = nimbus_app.connection(connection)
    connections[id] = new_connection

  all = -> Object.create(connections)

  get = (id) ->
    connections[id]

  remove = (id) ->
    connections.delete(id)

  update = (new_connection) ->
    connection = connections[new_connection.id]
    connection.update(new_connection)


  all: all
  add: add
  get: get
  remove: remove
  update: update