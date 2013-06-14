class ConfirmDropboxSessionWorker
  include Sidekiq::Worker

  def perform(connection_id)
    connection = DropboxConnection.find(connection_id)
    client = connection.session
    client.fetch_access_token! verifier: client.request_token_secret
    connection.update_attributes session: client, state: 'success'
  end
end