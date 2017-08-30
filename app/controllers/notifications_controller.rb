class NotificationsController < ApplicationController
	skip_before_action :authenticate_user!, only: [:new, :create]

    def create

    @choogle = Choogle.find_by_slug(params[:slug])

    @user = current_or_guest_user

    # Enter email
    # Search , if exist create notif with this id
    # If not update guest and create notif with this guest

    # we are looking in the db if we find a user with this email
    if User.find_by_email(user_params[:user][:email]).nil?
    	# if the email is not found we set it with the email in the input
        @user.email = user_params[:user][:email]
    	@user.save
    else
    	# error message (? if the email is found that's not a problem ?? why an error message ?)
    end

    @notification = Notification.new
    @notification.user = @user
    @notification.choogle = @choogle

    if @notification.save
    	# redirect en attendant de faire mieux en JS ? sortir de la modale ?
    	redirect_to choogle_path(params[:slug])
    else
    	# error message
    end

	end

	private

	def user_params
    params.require(:notification).permit({:user => [:email]})
  end

end
