class DropboxConnection < ActiveRecord::Base
  attr_accessible :session
  belongs_to :user
end
