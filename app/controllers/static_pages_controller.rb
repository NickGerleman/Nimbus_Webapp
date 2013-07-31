class StaticPagesController < ApplicationController

  def home
    if current_user
      redirect_to edit_user_path
    else
      render 'home'
    end
  end

end
