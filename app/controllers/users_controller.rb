class UsersController < ApplicationController

  def create
    @user = User.new params[:user]
    respond_to do |format|
      if Rails.env.test?
        @user.save
      else
        @user.save if verify_recaptcha(model: @user)
      end
      format.js
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html { render partial: 'layouts/register', layout: false }
    end
  end

  def destroy

  end

  def show
    redirect_to login_path if current_user.nil?
  end

  def settings

  end
end
