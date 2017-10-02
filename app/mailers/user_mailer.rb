class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user # Instance variable => available in view
    # We search the choogle concerns by the last notification
    @choogle = @user.notifications.last.choogle
    subject = @choogle.title

    @greeting = "Hi"
    mail(to: @user.email, subject: subject)
  end
  
end
