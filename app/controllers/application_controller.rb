class ApplicationController < ActionController::Base
  protect_from_forgery

  def default_url_options(opts={})
    ENV['HOST'] = ENV['HOST'] || '127.0.0.1:3000'
    Rails.env.production? ? protocol = 'https' : protocol = 'http'
    opts.merge(
        {
            protocol: protocol,
            host: ENV['HOST']
        })
  end

  # The object representing the current user or nil if no user is logged in
  def current_user
    @user ||= -> do
      #session can be stored in session cookie or independently depending on whether remember me was checked
      token = session[:session_token] || cookies[:session_token]
      return nil if token.blank?
      Session.get_user token
    end.call
  end

  #Whether there is a user logged in
  def logged_in?
    !current_user.nil?
  end

  helper_method :current_user, :logged_in?
end
