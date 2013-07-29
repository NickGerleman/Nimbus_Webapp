class FayeClientAuth

  def initialize(channel)
    @channel = channel
  end

  def outgoing(message, callback)
    message['ext'] ||= {}
    message['ext']['auth_token'] = Gibberish::HMAC(ENV['SOCKET_KEY'], @channel)
    callback.call(message)
  end
end

protocol = Rails.env.production? ? 'https://' : 'http://'
address = Rails.env.production? ? ENV['HOST'] : '127.0.0.1'
port = Rails.env.production? ? 443 : 8081
FAYE_URL = "#{protocol}#{address}:#{port}/socket"
