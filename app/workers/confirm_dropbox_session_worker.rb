class ConfirmDropboxSessionWorker
  include Sidekiq::Worker

  def perform(user_id)
    connection = User.find(user_id).dropbox_connection
    client = connection.session
    client.fetch_access_token! verifier: client.request_token_secret
    connection.update_attributes session: client, state: 'success'
  end
end