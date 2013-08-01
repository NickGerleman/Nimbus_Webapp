class PasswordResetsController < ApplicationController

  def new
    render partial: 'new', layout: false
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user
      user.update_attribute(:password_reset_token, SecureRandom.urlsafe_base64(32, false))
      UserMailer.delay.reset_password(user.id)
    else
      flash.now[:errors]=true
    end
  end

  def edit
    @token = params[:token]
    user = User.find_by(password_reset_token: @token)
    flash.now[:errors] = true unless user
  end

  def update
    @user = User.find_by(password_reset_token: params[:token])
    if @user
      if @user.update_attributes(password: params[:password], password_confirmation: params[:password_confirmation], email_confirmation: @user.email)
        @user.update_attribure(:password_reset_token, nil)
      end
    else
      render status: :not_found, text: 'Invalid Token'
    end
  end

end
