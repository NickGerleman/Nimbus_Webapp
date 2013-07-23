module ApplicationHelper

  # The page title created from a title suffix
  def title(title_suffix)
    title_base='Nimbus'
    return title_base if title_suffix.empty?
    "#{title_base} | #{title_suffix}"
  end

  def secure_protocol
    Rails.env.production? ? 'https' : 'http'
  end

  #whether the user is using a non desktop browser based on useragent
  def mobile?
      browser.mobile? || browser.tablet?
  end

  #whether the browser is outdated
  def outdated_browser?
    #cache results in the session in order to avoid needless checking on every visit
    session[:outdated] ||=
    (
      version = browser.full_version.to_f
      case
        when browser.chrome?
          version < 5 ? true : false
        when browser.ie?
          version < 10 ? true : false
        when browser.opera?
          version < 12 ? true : false
        when browser.firefox?
          version < 4 ? true : false
        when browser.safari?
          version < 5 ? true : false
        else false
      end
    )
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
