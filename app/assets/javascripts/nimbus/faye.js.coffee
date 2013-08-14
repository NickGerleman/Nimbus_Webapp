window.nimbus_app.faye = (promise, socket_uri, core) ->
  subscription = {}

  callback_handler = (message) ->
    message = JSON.parse(message)
    switch message.message_type
      when 'connection_update'
        connection = message.message_content
        core.connections.update(connection)
      when 'connection_remove'
        core.connections.remove(message.message_content.id)
      when 'client_message'
      else log 'Unknown Message Type: ' + message.message_type

  client = new Faye.Client(socket_uri, {timeout: 120})
  client.addExtension
    outgoing: (message, callback) ->
      message.ext ||= {}
      message.ext.auth_token = core.user.socket_token()
      callback(message)
  subscription = client.subscribe('/' + core.user.id(), callback_handler)
  subscription.callback ->
    promise.resolve()
  subscription.errback( -> alert 'Faye Subscription Failed')

  client