class UserMailer < ActionMailer::Base
  
  def password_reset_instructions user
    recipients  user.email
    from        "admin@teacherducklings.org"
    subject     "Teacher Ducklings -- Your Password Reset Instructions"
    sent_on     Time.now
    body        :user => user
  end

end