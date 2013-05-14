class RemoveExpiredSessionsWorker
  include Sidekiq::Worker

  def perform
    User.where('session_expiration <= ?', DateTime.current).each do |user|
      user.update_attribute :session_token, nil
      user.update_attribute :session_expiration, nil
    end
  end
end