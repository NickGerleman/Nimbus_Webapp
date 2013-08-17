'use strict'

# Gets the user's information and return the user object
window.nimbus_app.user = (promise) ->
  user_info = null
  $.getJSON '/api/user', (data) ->
    user_info = data
    promise.resolve()

  # The id of the user
  id: -> user_info.id
  # The user's socket token
  socket_token: -> user_info.socket_token