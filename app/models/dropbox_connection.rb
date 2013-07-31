class DropboxConnection < Connection
  serialize :session, Signet::OAuth2::Client

  def service_name
    'Dropbox'
  end

  def short_service_name
    'dropbox'
  end

end
