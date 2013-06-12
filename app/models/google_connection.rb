class GoogleConnection < ActiveRecord::Base
  belongs_to :user
  serialize :session, Signet::OAuth2::Client
  scope :hung, -> { where('state = ? AND created_at < ?', 'in_progress', Time.now.ago(2.minutes)) }
end
