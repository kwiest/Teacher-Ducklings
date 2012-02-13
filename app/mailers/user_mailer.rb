class UserMailer < ActionMailer::Base
  default from: 'admin@teacherducklings.org'
  
  def password_reset_instructions(user)
    @user = user
    mail(
      to: user.email,
      subject: 'Teacher Ducklings Password Reset Instructions',
      content_type: 'text/html',
      tag: 'teacherducklings-password-reset'
    )
  end

end
