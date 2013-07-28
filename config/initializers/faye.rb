faye_options = {
  mount: '/socket',
  timeout: 25,
  ping: 25,
  engine: {
   type: Faye::Redis,
   host: URI.parse(ENV["REDIS_URL"]).host
  }
}
FAYE = Faye::RackAdapter.new(NimbusWebapp::Application, faye_options)

# Taken and modified from Faye website
class ServerAuth
  def incoming(message, callback)
    # Let non-subscribe messages through
    return callback.call(message) unless message['channel'] == '/meta/subscribe'

    subscription = message['subscription']
    provided_token = message['ext'] && message['ext']['auth_token']
    expected_token = Gibberish::HMAC(ENV['SOCKET_KEY'], subscription)
    message['error'] = 'Invalid  auth token' unless expected_token == provided_token
    callback.call(message)
  end
end

FAYE.add_extension(ServerAuth.new)