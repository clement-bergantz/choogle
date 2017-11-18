class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user # Instance variable => available in view
    # We search the choogle concerns by the last notification
    @choogle = @user.notifications.last.choogle
    subject = @choogle.title

    @greeting = "Hi"
    mail(to: @user.email, subject: subject)
  end

  def results(choogle_id, user_id)
    @choogle = Choogle.find(choogle_id)
    @user = User.find(user_id)
    subject = @choogle.title

    @greeting = "Hi"
    mail(to: @user.email, subject: subject)
  end

end
