class StaticPagesController < ApplicationController
  caches_action(:new_user_home, :about, :features, :contribute)

  def home
     render 'static_pages/new_user_home'
  end

  def about

  end

  def features

  end

  def contribute

  end

end
