class UsersController < ApplicationController
  def login

  end

  def new
    @user = User.new

  end
end
