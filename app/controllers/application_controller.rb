class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    return @user unless @user.nil?
    token = session[:session_token]
    token = cookies[:session_token] unless cookies[:session_token].blank?
    return nil if token.blank?
    session = Session.find_by_token token
    return nil if session.nil?
    @user = session.user
  end

  def user_name
    return @name unless @name.blank?
    @name = current_user.name
  end

  def user_email
    return @email unless @email.blank?
    @email = current_user.name
  end

  def logged_in
    current_user.any?
  end

  helper_method :current_user, :user_name, :user_email, :logged_in
end
