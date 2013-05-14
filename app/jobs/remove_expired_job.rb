class RemoveExpiredJob
  def perform
    User.where(':session_expiration <= ?', DateTime.current).destroy_all
  end
end