class RemoveUnverifiedUsersWorker
  include Sidekiq::Worker

  # Remove Users that have been unverified for a weel
  def perform
    User.old_unverified.destroy_all
  end
end