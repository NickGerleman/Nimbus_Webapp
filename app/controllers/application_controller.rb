class ApplicationController < ActionController::Base
  protect_from_forgery

  def default_url_options(opts={})
    ENV['host'] = '127.0.0.1:3000' if ENV['host'].blank?
    Rails.env.production? ? protocol = 'https' : protocol = 'http'
    opts.merge(
        {
            protocol: protocol,
            host: ENV['host']
        })
  end

  # The object representing the current user or nil if no user is logged in
  def current_user
    return @user unless @user.nil?
    #session can be stored in session cookie or independently depending on whether remember me was checked
    token = session[:session_token]
    token = cookies[:session_token] unless cookies[:session_token].blank?
    return nil if token.blank?
    @user = Session.get_user token
  end

  #Whether there is a user logged in
  def logged_in?
    if current_user.nil?
      false
    else
      true
    end
  end

  helper_method :current_user, :logged_in?
end
