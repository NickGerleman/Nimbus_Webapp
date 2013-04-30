class UsersController < ApplicationController
  def login

  end

  def new
  end

  def create

    @user = User.new params[:user]
    if verify_recaptcha(model: @user) && @user.save
      flash[:register]=false
      redirect_to root_path
      #handle success
    else
      temp_user=@user
      flash[:register]=true
      render 'login'
      @user=temp_user
    end
  end
end
