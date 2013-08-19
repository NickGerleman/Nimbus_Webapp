class UsersController < ApplicationController

  # Create a new user
  def create
    @user = User.new user_params
    if Rails.env.production? and ENV['RECAPTCHA_PUBLIC_KEY']
      verify_recaptcha(model: @user)
      @user.save
    else
      @user.save
    end
  end

  # Display form for creating a new user
  def new
    @user = User.new
    render partial: 'new', layout: false
  end

  # Display form for deleting current user
  def delete
    render partial: 'delete', layout: false
  end

  # Delete the current user
  def destroy
    if current_user.authenticate params[:password]
      current_user.destroy
      flash[:mesasge] = 'Account Deleted Successfully'
    else
      @errors = true
    end
  end

  # The settings page
  def edit
    redirect_to new_session_path if current_user.nil?
  end

  # Shows the JSON representation of the user
  def show
    unless current_user
      render status: :not_found, text: 'User Not Logged In'
      return
    end
    render json: current_user
  end

  # Verifies the email address of a user
  def verify
    user = User.find_by_email_token(params[:token])
    if user.nil?
      @errors = true
    else
      user.verify
    end
  end

  # Resends the verification email
  def resend_verification
    if current_user and !current_user.verified
      current_user.send_verify_email
    else
      @errors = true
    end
  end

  private

  def user_params
    params.require(:user).permit(:email,
                                 :email_confirmation,
                                 :name,
                                 :password,
                                 :password_confirmation)
  end
end
