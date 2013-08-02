class PasswordResetsController < ApplicationController

  def new
    render partial: 'new', layout: false
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user
      user.generate_password_reset_token
      user.send_password_reset
    else
      @errors = true
    end
  end

  def edit
    @token = params[:token]
    user = User.find_by(password_reset_token: @token)
    @errors = true unless user
  end

  def update
    @user = User.find_by(password_reset_token: params[:token])
    if @user
      @user.update_reset_password(password: params[:password],
                                  password_confirmation: params[:password_confirmation])
    else
      render status: :not_found, text: 'Invalid Token'
    end
  end

end
