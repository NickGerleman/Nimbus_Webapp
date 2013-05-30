class SessionsController < ApplicationController

  # Create a new session
  #
  # @option params [String] :email the user's email address
  # @option params [String] :password the user's password
def create
    respond_to do |format|
      user = User.find_by_email params[:email]
      if user and user.authenticate params[:password]
        token = SecureRandom.urlsafe_base64 32, false
        if user.sessions.count > 2
          user.sessions.first.destroy
        end
        if params[:remember]
          user.sessions.create token: token, expiration: Time.now.advance(months: 1)
          cookies[:session_token] = {value: token, expires_in: 1.month, secure: Rails.env.production?}
        else
          user.sessions.create token: token, expiration: Time.now.advance(hours: 1)
          session[:session_token] = token
        end
        format.js
      else
        flash.now[:errors] = true
        format.js
      end
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
