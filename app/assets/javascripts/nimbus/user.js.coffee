window.nimbus_app.user = (promise, core) ->
  user_info = null
  $.getJSON '/api/user', (data) ->
    user_info = data
    promise.resolve()
  name = -> user_info.name
  id = -> user_info.id
  socket_token = -> user_info.socket_token

  {name: name, id: id, socket_token: socket_token}