class UsersController < ApplicationController

  # Create a new user and send a verification email
  #
  # @param [Hash] params form parameters
  def create
    @user = User.new params[:user]
    respond_to do |format|
      if Rails.env.test?
        @user.save
      else
        if  verify_recaptcha(model: user) and user.save
          UserMailer.delay.verify_email(user.id)
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
  # @param [Hash] params parameters given by POST
  # @option params [String] :password the password of the current user
  def destroy
    user = current_user
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
  # @param [Hash] params parameters provided by url
  # @option params [String] :id the emailed verification token
  def verify
    id = params[:id]
    user = User.find_by_email_token id
    if user.nil?
      flash.now[:incorrect]=true
    else
      user.verify
    end
  end

  def settings

  end
end
