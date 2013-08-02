class UpdateConnectionWorker
  include Sidekiq::Worker

  #Calls the User method to update the oauth token of connections soon to expire
  def perform()
    Connection.expires_soon.each { |connection| connection.update_token }
  end
end