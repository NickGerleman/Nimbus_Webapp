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

end
