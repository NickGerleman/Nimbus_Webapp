class SkydriveConnection < Connection
  serialize :session, Signet::OAuth2::Client

  def service_name
    'SkyDrive'
  end

  def short_service_name
    'skydrive'
  end
end
