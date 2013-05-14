class RemoveUnvalidatedJob
  def perform
    User.where(verified: false).destroy_all
  end
end