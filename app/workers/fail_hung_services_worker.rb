class FailHungServicesWorker
  include Sidekiq::Worker

  def perform
    DropboxConnection.hung.each do |c|
      c.update_attribute :state, 'error'
    end

    GoogleConnection.hung.each do |c|
      c.update_attribute :state, 'error'
    end
  end
end