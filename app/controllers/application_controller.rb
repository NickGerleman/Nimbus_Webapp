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

  def user_verified
    return @verified unless @verified.nil?
    @verified = current_user.verified
  end

  def logged_in?
    if current_user.nil?
      false
    else
      true
    end
  end

  def outdated_browser?
    return true if session[:outdated]
    return false if session[:modern]
    user_agent = AgentOrange::UserAgent.new request.env['HTTP_USER_AGENT']
    browser = user_agent.device.engine.browser
    name = browser.name
    version = browser.version.to_s.to_f
    case name
      when 'Chrome'
        if version < 4
          session[:outdated] = true
          true
        else
          session[:modern] = true
          false
        end
      when 'MSIE'
        if version < 10
          session[:outdated] = true
          true
        else
          session[:modern] = true
          false
        end
      when 'Opera'
        if version < 11.6
          session[:outdated] = true
          true
        else
          session[:modern] = true
          false
        end
      when 'Firefox'
        if version < 4
          session[:outdated] = true
          true
        else
          session[:modern] = true
          false
        end
      when 'Safari'
        if version < 4
          session[:outdated] = true
          true
        else
          session[:modern] = true
          false
        end
      else
        session[:modern] = true
        false
    end
  end

  helper_method :current_user, :user_name, :user_email, :user_verified, :logged_in?, :outdated_browser?
end
