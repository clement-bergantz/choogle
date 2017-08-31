class NotificationsController < ApplicationController
	skip_before_action :authenticate_user!, only: [:new, :create]

  def create

    @choogle = Choogle.find_by_slug(params[:slug])
    @user = current_or_guest_user

    # we are looking in the db if we find a user with this email
    if User.find_by_email(user_params[:user][:email]).nil?
    	# if the email is not found we set it with the email in the input
      @user.email = user_params[:user][:email]
    	@user.save
      @notification = Notification.new
      @notification.user = @user
      @notification.choogle = @choogle
    else
      # if the email is found we create a notification for the user founded
      registered_user = User.find_by_email(user_params[:user][:email])
      @notification = Notification.new
      @notification.user = registered_user
      @notification.choogle = @choogle
    end

    @notification.save
    flash[:notifyme] = "You will be notified by mail at the end of the votes."
    redirect_to choogle_path(params[:slug])
	end

	private

	def user_params
    params.require(:notification).permit({:user => [:email]})
  end

end
