class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    return @user unless @user.nil?
    return false if cookies[:session_token].nil?
    session = Session.find_by_token(cookies[:session_token])
    return false if session.nil?
    @user = session.user
  end

  helper_method :current_user
end
