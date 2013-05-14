class RemoveUnverifiedUsersWorker
  include Sidekiq::Worker

  def perform
    User.find_all_by_verified(false).each do |user|
      user.destroy if user.created_at < DateTime.current.ago(1.week)
    end
  end
end