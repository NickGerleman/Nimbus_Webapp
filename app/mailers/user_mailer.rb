class UserMailer < ActionMailer::Base
  default from: 'nimbusdev@nickgerleman.com'

  def verify_email(user)
    @token = user.email_token
    mail to: user.email, subject: 'Verify Your account'
  end
end
