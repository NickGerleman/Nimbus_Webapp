class RemoveUnverifiedUsersWorker
  include Sidekiq::Worker

  def perform
    User.old_unverified.destroy_all
  end
end