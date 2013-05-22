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

  def logged_in?
    if current_user.nil? then
      false
    else
      true
    end
  end

  def outdated_browser?
    user_agent = AgentOrange::UserAgent.new request.env['HTTP_USER_AGENT']
    browser = user_agent.device.engine.browser
    name = browser.name
    version = browser.version.to_s.to_f
    case name
      when 'Chrome'
        if version < 4 then
          true
        else
          false
        end
      when 'MSIE'
        if version < 10 then
          true
        else
          false
        end
      when 'Opera'
        if version < 11.6 then
          true
        else
          false
        end
      when 'Firefox'
        if version < 4 then
          true
        else
          false
        end
      when 'Safari'
        if version < 4 then
          true
        else
          false
        end
      else
        false
    end
  end

  helper_method :current_user, :user_name, :user_email, :logged_in?, :outdated_browser?
end
