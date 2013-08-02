module ApplicationHelper

  # The page title created from a title suffix
  def title(title_suffix)
    title_base='Nimbus'
    return title_base if title_suffix.empty?
    "#{title_base} | #{title_suffix}"
  end

  # HTTP or HTTPS depending on environment
  def secure_protocol
    Rails.env.production? ? 'https' : 'http'
  end

  # Whether the user is using a non desktop browser based on useragent
  def mobile?
    browser.mobile? || browser.tablet?
  end

  # The name of the current user
  def user_name
    raise 'No user' unless current_user
    @name ||= current_user.name
  end

  # The email address of the current user
  def user_email
    raise 'No user' unless current_user
    @email ||= current_user.name
  end

  # Whether the user has verified their email address
  def user_verified
    raise 'No user' unless current_user
    @verified ||= current_user.verified
  end


end
