class UsersController < ApplicationController

  def create
    @user = User.new params[:user]
    respond_to do |format|
      @user.save if Rails.env.test? or verify_recaptcha(model: @user)
      format.js
    end
  end

  def new
    if @user.nil?
      @user = User.new
    end
    respond_to do |format|
      format.html { render partial: 'layouts/register', layout: false }
    end
  end

  def destroy

  end

  def show

  end

  def settings

  end
end
