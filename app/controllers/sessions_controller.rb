class SessionsController < ApplicationController
  force_ssl(except: :destroy) if Rails.env.production?

  # Create a new session
  def create
    respond_to do |format|
      user = User.find_by_email params[:email]
      if user and user.authenticate params[:password]
        token = SecureRandom.urlsafe_base64
        user.sessions.first.destroy if user.sessions.count > 10
        if params[:remember]
          user.sessions.create token: token, expiration: Time.now.advance(months: 1)
          cookies[:session_token] = {value: token, expires_in: 1.month, secure: Rails.env.production?}
          session[:user] = user.id
        else
          session[:user] = user.id
        end
      else
        flash.now[:errors] = true
      end
      format.js
    end
  end

  # Destroys the current user's session
  def destroy
    session.clear
    cookies.delete :session_token
    Session.find_by_token(cookies[:session_token]).destroy unless cookies[:session_token].blank?
    @user=nil
    redirect_to root_url
  end

end
