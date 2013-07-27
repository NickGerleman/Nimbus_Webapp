json.cache! do
  connections = current_user.connections.reject {|c| c.state != 'success'}
  connections.each do |connection|
    json.set! connection.id do
      json.name connection.name
      json.type connection.short_service_name
      json.access_token connection.session.access_token
      json.last_updated connection.updated_at.iso8601
    end
  end
end