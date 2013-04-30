class UsersController < ApplicationController
  def login

  end

  def new
  end

  def create

    @user = User.new params[:user]
    if verify_recaptcha(model: @user) && @user.save
      flash[:register]=false
      flash[:success]=true
      render 'login'
    else
      flash[:register]=true
      render 'login'
    end
  end
end
