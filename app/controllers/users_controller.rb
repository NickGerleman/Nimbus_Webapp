class UsersController < ApplicationController
  force_ssl(except: :verify) if Rails.env.production?

  # Create a new user and send a verification email
  def create
    @user = User.new user_params
    respond_to do |format|
      if Rails.env.test?
        @user.save
      else
        if verify_recaptcha(model: @user) and @user.save
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
  def destroy
    if current_user.authenticate params[:password]
      current_user.destroy
      flash[:mesasge] = 'Account Deleted Successfully'
    else
      flash.now[:errors]=true
    end
  end

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
      flash.now[:incorrect]=true
    else
      user.verify
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
