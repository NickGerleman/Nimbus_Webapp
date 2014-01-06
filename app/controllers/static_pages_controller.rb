class StaticPagesController < ApplicationController

  # Render the homepage or the user's settings if logged in, will eventually be the actual app
  def home
    if current_user
      if current_user.connections.any?
        render 'app'
      else
        redirect_to edit_user_path
      end
    else
      render 'home'
    end
  end

end
