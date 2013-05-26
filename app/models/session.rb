class Session < ActiveRecord::Base
  attr_accessible :expiration, :token
  belongs_to :user
  scope :expired, lambda { where('expiration <= ?', Time.current) }

  def self.get_user(token)
    session = self.find_by_token token
    return nil if session.nil?
    session.user
  end
end
