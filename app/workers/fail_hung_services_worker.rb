class FailHungServicesWorker
  include Sidekiq::Worker

  # Fail services that are waiting for and have not recieved OAuth authorization in the past two
  # minutes
  def perform
    Connection.hung.each do |c|
      c.update_attribute :state, 'error'
    end
  end
end