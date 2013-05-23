class StaticPagesController < ApplicationController

  def home
    if logged_in?
      render 'users/show'
    else
      render 'home'
    end
  end

  def about

  end

  def features

  end

  def contribute

  end

end
