class UpdateConnectionWorker
  include Sidekiq::Worker

  def perform()
    Connection.expires_soon.each { |connection| connection.update_token }
  end
end