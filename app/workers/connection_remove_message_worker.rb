class ConnectionRemoveMessageWorker
  include Sidekiq::Worker
  require 'json'

  def perform(user_id, connection_id)
    channel = "/#{user_id}"
    message = {
     message_type: "connection_remove",
     message_content: {
       id: connection_id
     }
    }
    json_message = JSON.dump(message)
    client = Faye::Client.new(FAYE_URL)
    client.add_extension(FayeClientAuth.new)
    client.subscribe(channel)
    client.publish(channel, json_message)
    client.unsubscribe(channel)
  end
end