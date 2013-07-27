json.cache! do
  json.(current_user, :name, :id)
  json.socket_token(Gibberish::HMAC(ENV['SOCKET_KEY'], current_user.id))
  json.connections { json.partial!('connections/show') }
end