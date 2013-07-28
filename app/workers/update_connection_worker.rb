class UpdateConnectionWorker
  include Sidekiq::Worker

  def perform()
    Connection.expires_soon.each do |connection|
      session = connection.session
      session.fetch_access_token!
      issue_time = Time.parse(session.issued_at)
      expires_at = issue_time.since(1.hour)
      connection.update(session: session, expires_at: expires_at)
      ConnectionUpdateMessageWorker.perform_async(connection.id)
    end
  end
end