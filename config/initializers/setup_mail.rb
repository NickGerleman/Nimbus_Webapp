ActionMailer::Base.smtp_settings = {
    :address              => env['SMTP_SERVER'],
    :port                 => 587,
    :domain               => env['MAIL_DOMAIN'],
    :user_name            => env['MAIL_USER'],
    :password             => env['MAIL_PASSWORD'],
    :authentication       => 'plain',
    :enable_starttls_auto => true
}