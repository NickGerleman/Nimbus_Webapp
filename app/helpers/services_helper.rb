module ServicesHelper

  def state(service)
    user = current_user
    case service
      when :dropbox
        if user.dropbox_connection.nil?
          return :none
        end
        if user.dropbox_connection.completed.nil?
          return :in_progress
        end
        if user.dropbox_connection.completed
          return :success
        else
          return :error
        end
      else
        raise ArgumentError
    end
  end
end