class StaticPagesController < ApplicationController

  def home
    if logged_in?
      render 'users/show'
    else
      render 'home'
    end
  end

end
