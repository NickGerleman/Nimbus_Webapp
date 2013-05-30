class FailHungServicesWorker
  include Sidekiq::Worker

  def perform
    DropboxConnection.hung.joins(GoogleConnection.hung).each do |c|
      c.update_attribute :state, 'error'
    end
  end
end