class NotificationsController < ApplicationController
	skip_before_action :authenticate_user!, only: [:new, :create]

	def create
	
		@choogle = Choogle.find_by_slug(params[:slug])

    @user = current_or_guest_user

    # we are looking in the db if we find a user with this email
    if User.find_by_email(user_params[:user][:email]).nil?
    	@user.email = user_params[:user][:email]
    	# mettre un if sur le save ?
    	@user.save
    else
    	# error message
    	raise
    end
   
    @notification = Notification.new
    @notification.user = @user
    @notification.choogle = @choogle

    if @notification.save
    	# redirect en attendant de faire mieux en JS ? sortir de la modale ?
    	redirect_to choogle_path(params[:slug])
    else
    	render :new
    end
    
	end

	private

	def user_params
    params.require(:notification).permit({:user => [:email]})
  end

end
