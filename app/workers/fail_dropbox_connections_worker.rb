class FailDropboxConnectionsWorker
  include Sidekiq::Worker

  def perform
    DropboxConnection.hung.each do |c|
      c.update_attribute :completed, false
    end
  end
end