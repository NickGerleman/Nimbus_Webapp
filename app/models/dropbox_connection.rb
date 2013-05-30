class DropboxConnection < ActiveRecord::Base
  belongs_to :user
  scope :hung, -> { where('state = ? AND created_at < ?', 'in_progress', Time.current.ago(5.minutes)) }
end
