class FayeClientAuth
  def outgoing(message, callback)
    return callback.call(message) unless message['channel'] == '/meta/subscribe'
    subscription = message['subscription'].slice(1)
    message['ext'] ||= {}
    message['ext']['auth_token'] = Gibberish::HMAC(ENV['SOCKET_KEY'], subscription)
    callback.call(message)
  end
end

protocol = Rails.env.production? ? 'https://' : 'http://'
address = Rails.env.production? ? ENV['HOST'] : '127.0.0.1'
port = Rails.env.production? ? 443 : 8081
url = "#{protocol}#{address}:#{port}/socket"
Thread.new do
  EM.run do
    FAYE = Faye::Client.new(url)
    client.add_extension(FayeClientAuth.new)
  end
end