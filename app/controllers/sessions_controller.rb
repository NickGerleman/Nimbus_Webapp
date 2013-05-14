class SessionsController < ApplicationController
  def create
    respond_to do |format|
      user = User.find_by_email params[:email]
      token = SecureRandom.urlsafe_base64 32, false
      if user and user.authenticate params[:password]
        if params[:remember]
          user.sessions.create token: token, expiration: DateTime.current.advance(months: 1)
          cookies[:session_token] = {value: token, expires_in: 1.month}
        else
          user.sessions.create token: token, expiration: DateTime.current.advance(hours: 1)
          cookies[:session_token] = {value: token, expires_in: 1.hour}
        end
        format.js
      else
        flash.now[:errors] = true
        format.js
      end
    end
  end

  def destroy
    token = cookies[:session_token]
    cookies.delete :session_token
    Session.find_by_token(token).destroy
    @user=nil
    redirect_to root_url
  end
end
