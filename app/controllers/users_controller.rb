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
    user = User.find(params[:id])
    if current_user.authenticate params[:password]
      user.destroy
    else
      flash.now[:errors]=true
    end
    respond_to { |f| f.js }
  end

  def show
    respond_to do |format|
      format.html { redirect_to login_path if current_user.nil? }
      format.json do
       render status: :not_found, text: 'User Not Logged In' unless current_user
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

  #blank methods are here so https will be properly forced on these actions
  def settings

  end

  def login

  end

  private

  def user_params
    params.require(:user).permit(:email, :email_confirmation, :name, :password, :password_confirmation)
  end
end
