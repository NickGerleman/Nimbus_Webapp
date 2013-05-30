class Session < ActiveRecord::Base
  belongs_to :user
  scope :expired, -> { where('expiration <= ?', Time.now) }

  def self.get_user(token)
    session = self.find_by_token token
    return nil if session.nil?
    session.user
  end
end
