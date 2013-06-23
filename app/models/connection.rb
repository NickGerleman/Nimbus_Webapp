class Connection < ActiveRecord::Base
  belongs_to :user
  scope :hung, -> { where('state = ? AND created_at < ?', 'in_progress', Time.now.ago(1.minute)) }
end