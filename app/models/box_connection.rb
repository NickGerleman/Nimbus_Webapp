class BoxConnection < Connection
  serialize :session, Signet::OAuth2::Client

  def service_name
    'box'
  end

  def short_service_name
    'box'
  end

end
