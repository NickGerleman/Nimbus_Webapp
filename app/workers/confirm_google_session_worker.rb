require 'signet/oauth_2/client'

class ConfirmGoogleSessionWorker
  include Sidekiq::Worker

  def perform(user_id, code)
    connection = User.find(user_id).google_connection
    client = connection.session
    client.code=code
    client.fetch_access_token!
    connection.update_attributes(session: client, state: 'success')
  end
end