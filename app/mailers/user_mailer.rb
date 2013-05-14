class UserMailer < ActionMailer::Base
  default from: 'nimbusdev@nickgerleman.com'

  def verify_email(user)
    @token = verify_url
    mail to: user.email, subject: 'Verify Your account'
  end
end
