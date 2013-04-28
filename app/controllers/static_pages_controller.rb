class StaticPagesController < ApplicationController
  def home
    expires_in 1.day, public: true
  end

  def about
    expires_in 1.day, public: true

  end

  def features
    expires_in 1.day, public: true

  end

  def contribute
    expires_in 1.day, public: true
  end
end
