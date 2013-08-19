class SessionsController < ApplicationController

  # Create a new session
  def create
    user = User.find_by_email params[:email]
    if user and user.authenticate params[:password]
      token = SecureRandom.urlsafe_base64
      user.sessions.first.destroy if user.sessions.count > 10
      if params[:remember]
        user.sessions.create token: token, expiration: Time.now.advance(months: 1)
        cookies[:session_token] = {value: token, expires_in: 1.month, secure: Rails.env.production?}
      end
      session[:user] = user.id
    else
      @errors = true
    end
  end

  # Destroys the current user's session
  def destroy
    session[:user] = nil
    cookies.delete :session_token
    Session.find_by_token(cookies[:session_token]).destroy unless cookies[:session_token].blank?
    @user=nil
    redirect_to root_url
  end

  # Blank method is included here so the force_ssl option will work for the new page
  def new

  end

end
