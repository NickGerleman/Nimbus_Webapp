'use strict'

# Initializes and returns the connection manager
window.nimbus_app.connections_manager = (promise) ->

  connections = {}

  $.ajax
    url: '/api/user/connections'
    dataType: 'JSON'
    success: (data) ->
      add(connection) for connection in data
      promise.resolve()
    error: -> promise.reject()

  # Adds a new connection (in API form)
  add = (connection) ->
    id = connection.id
    new_connection = nimbus_app.connection(connection)
    connections[id] = new_connection

  # Returns an array containing each connection
  # (actually an object with a prototype of each connection, prevents ccidental modification)
  all = ->
    connections_array = []
    for own id, connection of connections
      connections_array.push(Object.create(connection))
    connections_array

  # Removes the connection with the specified ID
  remove = (id) ->
    connections.delete(id)

  # Updates a connection with it's new version
  update = (new_connection) ->
    connection = connections[new_connection.id]
    connection.update(new_connection)


  add: add
  all: all
  remove: remove
  update: update