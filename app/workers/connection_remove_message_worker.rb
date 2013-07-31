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
    FAYE.subscribe(channel)
    FAYE.publish(channel, json_message)
    FAYE.unsubscribe(channel)
  end
end