json.cache! current_user do
  json.(current_user, :name, :id)
  json.socket_token(Gibberish::HMAC(ENV['SOCKET_KEY'], current_user.id))
end
json.connections { json.partial!('connections/show') }
