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
      #session can be stored in session cookie or independently depending on whether remember me was checked
      token = session[:session_token] || cookies[:session_token]
      token.blank? ? nil : Session.get_user(token)
    )
  end

  helper_method :current_user
end
