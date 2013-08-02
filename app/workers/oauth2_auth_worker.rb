class Oauth2AuthWorker
  include Sidekiq::Worker

  # Calls the user method to use a code for OAuth authorization
  def perform(connection_id, code)
    connection = Connection.find(connection_id)
    connection.authorize(code) if connection
  end
end