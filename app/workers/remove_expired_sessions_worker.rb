class RemoveExpiredSessionsWorker
  include Sidekiq::Worker

  def perform
    Session.expired.destroy_all
  end
end