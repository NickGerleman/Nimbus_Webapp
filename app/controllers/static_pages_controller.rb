class StaticPagesController < ApplicationController
  caches_action(:home, :about, :features, :contribute)
  def home
  end

  def about

  end

  def features

  end

  def contribute
  end

end
