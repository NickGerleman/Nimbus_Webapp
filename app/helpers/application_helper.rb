module ApplicationHelper
  # The page title created from a title suffix
  def title(title_suffix)
    title_base='Nimbus'
    return title_base if title_suffix.empty?
    "#{title_base} | #{title_suffix}"
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

  #whether the browser is outdated
  def outdated_browser?
    #cache results in the session cookie in order to avoid needless recomputation on every visit
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

  # The name of the current user
  #
  # @raise [RuntimeError] if there is no current user
  def user_name
    raise 'No user' unless logged_in?
    return @name unless @name.blank?
    @name = current_user.name
  end

  # The email address of the current user
  #
  # @raise [RuntimeError] if there is no current user
  def user_email
    raise 'No user' unless logged_in?
    return @email unless @email.blank?
    @email = current_user.name
  end

  # Whether the user has verified their email address
  #
  # @raise [RuntimeError] if there is no current user
  def user_verified
    raise 'No user' unless logged_in?
    return @verified unless @verified.nil?
    @verified = current_user.verified
  end

  #Whether there is a user logged in
  def logged_in?
    if current_user.nil?
      false
    else
      true
    end
  end

end
