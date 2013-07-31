class UpdateConnectionWorker
  include Sidekiq::Worker

  def perform()
    Connection.expires_soon.each do |connection|
      begin
        session = connection.session
        session.fetch_access_token!
        issue_time = session.issued_at
        expires_at = issue_time.since(1.hour)
        connection.update_attributes(session: session, expires_at: expires_at)
        ConnectionUpdateMessageWorker.perform_async(connection.user.id, connection.id)
      rescue Signet::AuthorizationError
        connection.update_attribute(:state, 'expired')
      end
    end
  end
end