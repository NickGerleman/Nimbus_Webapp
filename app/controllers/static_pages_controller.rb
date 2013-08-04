class StaticPagesController < ApplicationController

  # Render the homepage or the user's settings if logged in, will eventually be the actual app
  def home
    if current_user
      render 'app'
    else
      render 'home'
    end
  end

end
