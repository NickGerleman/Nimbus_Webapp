class UsersController < ApplicationController

  # Create a new user and send a verification email
  def create
    @user = User.new user_params
    respond_to do |format|
      if Rails.env.test?
        @user.save
      else
        if  verify_recaptcha(model: @user) and @user.save
          UserMailer.delay.verify_email(@user.id)
        end
      end
      format.js
    end
  end

  # Display form for creating a new user
  def new
    @user = User.new
    respond_to do |format|
      format.html { render partial: 'register', layout: false }
    end
  end

  # Display form for deleting current user
  def delete
    render partial: 'delete', layout: false
  end

  # Delete the current user if authentication successful, otherwise show errors
  #
  # @option params [String] :password the password of the current user
  def destroy
    user = User.find(params[:id])
    if current_user.authenticate params[:password]
      user.destroy
    else
      flash.now[:errors]=true
    end
    respond_to { |f| f.js }
  end

  def show
    redirect_to login_path if current_user.nil?
  end

  # Verifies the email address of a user
  #
  # @option params [String] :id the emailed verification token
  def verify
    user = User.find_by_email_token(params[:token])
    if user.nil?
      flash.now[:incorrect]=true
    else
      user.verify
    end
  end

  def settings

  end

  private

  def user_params
    params.require(:user).permit(:email, :email_confirmation, :name, :password, :password_confirmation)
  end
end
