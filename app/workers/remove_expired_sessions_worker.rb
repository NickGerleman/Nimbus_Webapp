class RemoveExpiredSessionsWorker
  include Sidekiq::Worker

  def perform
    Session.where('expiration <= ?', DateTime.current).destroy_all
  end
end