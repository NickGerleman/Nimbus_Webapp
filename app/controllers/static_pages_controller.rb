class StaticPagesController < ApplicationController
  def home
    expires_in 30.days, public: true
  end

  def about
    expires_in 30.days, public: true

  end

  def features
    expires_in 30.days, public: true

  end

  def contribute
    expires_in 30.days, public: true
  end
end
