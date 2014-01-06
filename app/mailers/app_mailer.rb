class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: @user.email, from: "info@netflix-clone.com", subject: "Welcome to Netflix Clone!"
  end
end
