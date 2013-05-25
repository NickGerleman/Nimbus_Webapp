class FailDropboxConnectionsWorker
  include Sidekiq::Worker

  def perform
    DropboxConnection.where('completed IS null AND created_at < ?', DateTime.current.ago(5.minutes)).each do |c|
      c.update_attribute :completed, false
    end
  end
end