class Oauth2AuthWorker
  include Sidekiq::Worker

  def perform(connection_id, code)
    connection = Connection.find(connection_id)
    connection.authorize(code) if connection
  end
end