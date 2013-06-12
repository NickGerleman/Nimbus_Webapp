module ServicesHelper

  def state(service)
    case service
      when :dropbox
        connection = current_user.dropbox_connection
        @dropbox_state ||= connection.nil? ? :none : connection.state.to_sym
      when :google
        connection = current_user.google_connection
        @google_state ||= connection.nil? ? :none : connection.state.to_sym
      else
        raise 'Invalid Service'
    end
  end
end