class RemoveExpiredSessionsWorker
  include Sidekiq::Worker

  # Remove all expired sessions from the DB
  def perform
    Session.expired.destroy_all
  end
end