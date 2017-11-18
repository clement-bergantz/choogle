class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :choogle

  after_create :send_welcome_email

  private

  def send_welcome_email
    UserMailer.welcome(self.user).deliver_later
  end

end
