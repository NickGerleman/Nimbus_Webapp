class Connection < ActiveRecord::Base

  validates :type, presence: true
  validates :user_id, presence: true
  validates :name, length: {minimum: 1, maximum: 64}

  after_save { ConnectionUpdateMessageWorker.perform_async(user.id, id) }
  after_destroy { ConnectionRemoveMessageWorker.perform_async(user.id, id) }

  belongs_to :user

  scope :hung, -> do
    where('state = ? AND created_at < ?', 'in_progress', Time.now.ago(1.minute))
  end

  scope :expires_soon, -> do
    where("type != 'DropboxConnection' AND expires_at < ?", Time.now.since(50.minutes))
  end

  def to_partial_path
    'connections/connection'
  end

  def update_token
    unless type == 'DropboxConnection'
      session.fetch_access_token!
      issue_time = session.issued_at
      expires_at = issue_time.since(1.hour)
      update_attributes(session: session, expires_at: expires_at)
    end
  rescue Signet::AuthorizationError
    update_attribute(:state, 'expired')
  end

  def authorize(code)
    client = self.session
    client.code = code
    client.fetch_access_token!
    update_attributes(session: client, state: 'success')
  end

end