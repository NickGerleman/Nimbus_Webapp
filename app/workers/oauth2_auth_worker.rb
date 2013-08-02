class Oauth2AuthWorker
  include Sidekiq::Worker

  def perform(connection_id, code)
    connection = Connection.find(connection_id)
    client = connection.session
    client.code = code
    client.fetch_access_token!
    connection.update_attributes(session: client, state: 'success')
  end
end