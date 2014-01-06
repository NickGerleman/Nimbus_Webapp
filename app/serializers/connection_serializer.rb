class ConnectionSerializer < ActiveModel::Serializer
  root false
  attributes :name, :id, :type, :access_token, :last_updated, :state

  def type
    object.short_service_name
  end

  def access_token
    object.session.access_token
  end

  def last_updated
    object.updated_at.iso8601
  end

end
