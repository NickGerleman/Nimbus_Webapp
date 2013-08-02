class StaticPagesController < ApplicationController

  # Render the homepage or the user's settings if logged in, will eventually be the actual app
  def home
    if current_user
      redirect_to edit_user_path
    else
      render 'home'
    end
  end

end
