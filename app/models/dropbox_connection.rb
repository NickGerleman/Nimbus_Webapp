class DropboxConnection < ActiveRecord::Base
  attr_accessible :session
  belongs_to :user
  scope :hung, lambda { where('completed IS null AND created_at < ?', Time.current.ago(5.minutes)) }
end
