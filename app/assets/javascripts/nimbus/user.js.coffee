'use strict'

# Gets the user's information and return the user object
window.NimbusApp.User = (promise) ->
  user_info = null
  $.ajax
    url: '/api/user'
    dataType: 'JSON'
    success: (data) ->
      user_info = data
      promise.resolve()
    error: -> promise.reject()

  # The id of the user
  id: -> user_info.id
  # The user's socket token
  socket_token: -> user_info.socket_token