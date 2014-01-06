'use strict'

# Initializes and returns the connection manager
window.NimbusApp.ConnectionManager = (promise) ->

  connections = {}
  contains_expired = false

  internal_promise = $.Deferred()
  internal_promise.done (connections) ->
    add(connection) for connection in connections
    promise.resolve()
  internal_promise.fail (reason) -> promise.reject(reason)
  window.get_connections(internal_promise)

  # Adds a new connection (in API form)
  add = (connection) ->
    if connection.state != 'success'
      contains_expired = true
      return
    id = connection.id
    new_connection = NimbusApp.Connection(connection)
    connections[id] = new_connection

  # Returns an array containing each connection
  # (actually an object with a prototype of each connection, prevents accidental modification)
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

  #Whether one of the connections is not ready
  contains_expired: -> contains_expired
  add: add
  all: all
  remove: remove
  update: update