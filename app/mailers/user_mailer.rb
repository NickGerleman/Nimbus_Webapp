class UserMailer < ActionMailer::Base
  default from: 'Nimbus Support <support@nimbuu.us>'

  def verify_email(user_id)
    user = User.find user_id
    @token = user.email_token
    mail to: user.email, subject: 'Verify Your Nimbus Account'
  end

  def reset_password(user_id)
    user = User.find user_id
    @token = user.password_reset_token
    mail to: user.email, subject: 'Reset Your Nimbus Password'
  end
end
