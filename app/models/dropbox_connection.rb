class DropboxConnection < ActiveRecord::Base
  belongs_to :user
  serialize :session, Signet::OAuth1::Client
  scope :hung, -> { where('state = ? AND created_at < ?', 'in_progress', Time.now.ago(2.minutes)) }

  def service_name
    'Dropbox'
  end

  def short_service_name
    'dropbox'
  end
end
