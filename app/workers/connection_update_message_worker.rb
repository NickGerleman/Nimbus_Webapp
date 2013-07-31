class ConnectionUpdateMessageWorker
  include Sidekiq::Worker
  require 'json'

  def perform(user_id, connection_id)
    channel = "/#{user_id}"
    connection = Connection.find(connection_id)
    connection = ConnectionSerializer.new(connection).serializable_hash
    message = {
        message_type: "connection_update",
        message_content: connection
    }
    json_message = JSON.dump(message)
    FAYE.subscribe(channel)
    FAYE.publish(channel, json_message)
    FAYE.unsubscribe(channel)
  end
end