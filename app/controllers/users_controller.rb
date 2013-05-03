class UsersController < ApplicationController

  def create
    @user = User.new params[:user]
    respond_to do |format|
    if verify_recaptcha(model: @user) && @user.save
      format.js
    else
      format.js
      end
    end
  end

  def destroy

  end

  def show

  end

  def settings

  end
end
