class UsersController < ApplicationController
  force_ssl(except: :verify) if Rails.env.production?

  # Create a new user
  def create
    @user = User.new user_params
    respond_to do |format|
      if Rails.env.test?
        @user.save
      else
        verify_recaptcha(model: @user)
        @user.save
      end
      format.js
    end
  end

  # Display form for creating a new user
  def new
    @user = User.new
    respond_to do |format|
      format.html { render partial: 'new', layout: false }
    end
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

  def show
    respond_to do |format|
      format.json do
        unless current_user
          render status: :not_found, text: 'User Not Logged In'
          return
        end
        render json: current_user
      end
    end
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
