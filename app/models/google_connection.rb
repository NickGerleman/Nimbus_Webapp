class GoogleConnection < Connection
  serialize :session, Signet::OAuth2::Client

  def service_name
    'Google'
  end

  def short_service_name
    'google'
  end
end
