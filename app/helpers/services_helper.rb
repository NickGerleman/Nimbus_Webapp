module ServicesHelper

  def state(service)
    case service
      when :dropbox
        current_user.dropbox_connection.nil? ? 'none' : current_user.dropbox_connection.state
      when :google
        current_user.google_connection.nil? ? 'none' : current_user.google_connection.state
      else
        raise 'Invalid Service'
    end
  end
end