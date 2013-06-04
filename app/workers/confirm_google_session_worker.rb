require 'google/api_client'

class ConfirmGoogleSessionWorker
  include Sidekiq::Worker

  def perform(user_id, auth_token)
    connection = User.find(user_id).google_connection
    serialized_session = connection.session
    client = Marshal.load(serialized_session)
    client.authorization.code = auth_token
    client.authorization.fetch_access_token!
    connection.update_attributes session: Marshal.dump(client), state: 'success'
  end
end