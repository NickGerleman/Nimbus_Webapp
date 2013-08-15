# Gets the user's information
#
# @param promise a Defeered to resolove when user is retrieved
# @returns a user object
window.nimbus_app.user = (promise) ->
  user_info = null
  $.getJSON '/api/user', (data) ->
    user_info = data
    promise.resolve()


  id: -> user_info.id
  name: -> user_info.name
  socket_token: -> user_info.socket_token