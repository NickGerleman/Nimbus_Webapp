# Initializes the Faye Client
#
# @param opts
# @option opts socket_uri the URI for Faye to connect to
# @option opts socket_token the token to use to connect
# @option opts user_id the users id
# @option opts promise a Deffered to resolve when subscription complete
# @option opts update_callback the function to call on a connection_update message
# @option opts remove_callback the function to call on a connection_remove message
# @returns the faye client
window.nimbus_app.faye = (opts) ->
  subscription = {}

  client = new Faye.Client(opts.socket_uri, {timeout: 120})
  client.addExtension
    outgoing: (message, callback) ->
      message.ext ||= {}
      message.ext.auth_token = opts.socket_token
      callback(message)
  subscription = client.subscribe('/' + opts.user_id, callback_handler)
  subscription.callback ->
    opts.promise.resolve()
  subscription.errback( -> alert 'Faye Subscription Failed')

  callback_handler = (message) ->
    message = JSON.parse(message)
    switch message.message_type
      when 'connection_update'
        connection = message.message_content
        opts.update_callback(connection)
      when 'connection_remove'
        opts.remove_callback(message.message_content.id)
      when 'client_message'
        console.log 'Unimplemented Client Feature'
      else console.log 'Unknown Message Type: ' + message.message_type


  client