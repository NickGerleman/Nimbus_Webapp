ActionMailer::Base.smtp_settings = {
    :address              => ENV['SMTP_SERVER'],
    :port                 => 587,
    :domain               => ENV['MAIL_DOMAIN'],
    :user_name            => ENV['MAIL_USER'],
    :password             => ENV['MAIL_PASSWORD'],
    :authentication       => 'plain',
    :enable_starttls_auto => true
}