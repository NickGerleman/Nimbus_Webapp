class PasswordResetsController < ApplicationController

  # Show form for reseting the password
  def new
    render partial: 'new', layout: false
  end

  # Process the email address, create a reset token and send it to the user
  def create
    user = User.find_by(email: params[:email].downcase)
    if user
      user.generate_password_reset_token
      user.send_password_reset
    else
      @errors = true
    end
  end

  # Display page for changing password
  def edit
    @token = params[:token]
    user = User.find_by(password_reset_token: @token)
    @errors = true unless user
  end

  # Change the password
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
