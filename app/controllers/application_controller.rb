class ApplicationController < ActionController::Base
  protect_from_forgery

  #URL options
  def default_url_options
    {
      host: ENV['HOST'] || '127.0.0.1:8080',
      protocol: Rails.env.production? ? 'https' : 'http'
    }
  end

  # The object representing the current user or nil if no user is logged in
  def current_user
    @user ||= (
      user_id =
      session[:user] ||= (cookies[:session_token] ? Session.get_user(cookies[:session_token]) : nil)
      user_id ? User.find(user_id) : nil
    )
  end

  helper_method :current_user
end
