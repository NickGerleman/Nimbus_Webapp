class UsersController < ApplicationController

  def create
    user = User.new params[:user]
    respond_to do |format|
      if Rails.env.test?
        user.save
      else
        if  verify_recaptcha(model: user) and user.save
          UserMailer.delay.verify_email(user)
        end
      end
      format.js
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html { render partial: 'register', layout: false }
    end
  end

  def delete
    render partial: 'delete', layout: false
  end

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
