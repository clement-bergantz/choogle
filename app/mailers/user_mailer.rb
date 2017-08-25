class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome(user)
    @user = user # Instance variable => available in view
    @choogle = @user.notifications.last.choogle
    raise
    subject = @choogle.title

    @greeting = "Hi"
    mail(to: @user.email, subject: subject)
  end
end
