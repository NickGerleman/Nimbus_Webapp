class FailDropboxConnectionsWorker
  include Sidekiq::Worker

  def perform
    DropboxConnection.where('created_at < ?', DateTime.current.ago(5.minutes)).each do |connection|
      connection.update_attribute :completed, false
    end
  end
end