module ApplicationHelper

  # The page title created from a title suffix
  def title(title_suffix)
    title_base='Nimbus'
    return title_base if title_suffix.empty?
    "#{title_base} | #{title_suffix}"
  end

  #whether the browser is outdated
  def outdated_browser?
    #cache results in the session cookie in order to avoid needless recomputation on every visit
    return true if session[:outdated]
    return false if session[:modern]
    version = browser.full_version.to_f
    case
      when browser.chrome?
        if version < 4
          session[:outdated] = true
          true
        else
          session[:modern] = true
          false
        end
      when browser.ie?
        if version < 10
          session[:outdated] = true
          true
        else
          session[:modern] = true
          false
        end
      when browser.opera?
        if version < 12
          session[:outdated] = true
          true
        else
          session[:modern] = true
          false
        end
      when browser.firefox?
        if version < 4
          session[:outdated] = true
          true
        else
          session[:modern] = true
          false
        end
      when browser.safari?
        if version < 4.1
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
    raise 'No user' unless current_user
    @name ||= current_user.name
  end

  # The email address of the current user
  #
  # @raise [RuntimeError] if there is no current user
  def user_email
    raise 'No user' unless current_user
    @email ||= current_user.name
  end

  # Whether the user has verified their email address
  #
  # @raise [RuntimeError] if there is no current user
  def user_verified
    raise 'No user' unless current_user
    @verified ||= current_user.verified
  end



end
