class DropboxConnection < ActiveRecord::Base
  belongs_to :user
  scope :hung, -> { where('completed IS null AND created_at < ?', Time.current.ago(5.minutes)) }
end
