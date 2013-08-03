class FayeClientAuth

  def outgoing(message, callback)
    message['ext'] ||= {}
    message['ext']['auth_token'] = ENV['SOCKET_MASTER']
    callback.call(message)
  end
end

protocol = Rails.env.production? ? 'https://' : 'http://'
address = Rails.env.production? ? ENV['HOST'] : '127.0.0.1'
port = Rails.env.production? ? 443 : 8081
url = "#{protocol}#{address}:#{port}/api/socket"

Thread.new do
  EM.run do
    FAYE = Faye::Client.new(url)
    FAYE.log_level = :warn
    FAYE.add_extension(FayeClientAuth.new)
  end
end