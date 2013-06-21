class SessionsController < ApplicationController

  # Create a new session
  def create
    respond_to do |format|
      user = User.find_by_email params[:email]
      if user and user.authenticate params[:password]
        token = SecureRandom.urlsafe_base64 32, false
        user.sessions.first.destroy if user.sessions.count > 10
        if params[:remember]
          user.sessions.create token: token, expiration: Time.now.advance(months: 1)
          cookies[:session_token] = {value: token, expires_in: 1.month, secure: Rails.env.production?}
        else
          user.sessions.create token: token, expiration: Time.now.advance(hours: 1)
          session[:session_token] = token
        end
      else
        flash.now[:errors] = true
      end
      format.js
    end
  end

  # Destroys the current user's session
  def destroy
    token = cookies[:session_token]
    cookies.delete :session_token
    Session.find_by_token(token).destroy unless token.blank?
    @user=nil
    session.clear
    redirect_to root_url
  end
end
