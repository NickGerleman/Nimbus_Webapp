class Connection < ActiveRecord::Base

  validates :type, presence: true
  validates :user_id, presence: true

  belongs_to :user
  scope :hung, -> { where('state = ? AND created_at < ?', 'in_progress', Time.now.ago(1.minute)) }
  scope :expires_soon, -> {where('type != "DropboxConnection" AND expires_at < ?', Time.now.since(50.minutes))}

end