class FailHungServicesWorker
  include Sidekiq::Worker

  def perform
    Connection.hung.each do |c|
      c.update_attribute :state, 'error'
    end
  end
end