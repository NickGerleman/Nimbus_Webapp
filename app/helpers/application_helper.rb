module ApplicationHelper
  # The page title created from a title suffix
  def title(title_suffix)
    title_base='Nimbus'
    return title_base if title_suffix.empty?
    "#{title_base} | #{title_suffix}"
  end

  #whether the browser is outdated
  def outdated_browser?
    return false if Rails.env.test?
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



end
