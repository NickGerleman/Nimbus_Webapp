class StaticPagesController < ApplicationController

  def home
    if current_user
      render 'users/show'
    else
      render 'home'
    end
  end

end
