class Session < ActiveRecord::Base

  validates :token, presence: true, uniqueness: {case_sensitive: true}
  validates :expiration, presence: true
  validates :user_id, presence: true

  after_find { |session| session.destroy if session.expired? }

  belongs_to :user
  scope :expired, -> { where('expiration <= ?', Time.now) }

  # Finds the user who owns the session with the corresponding token
  def self.get_user(token)
    session = self.find_by_token token
    return nil if session.nil? or session.expired?
    session.user
  end

  # Whether the session has expired
  def expired?
    self.expiration < Time.now
  end
end
