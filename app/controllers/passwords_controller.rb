class PasswordsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    # verify if already logged in, if redirect to home
    if session[:guest_user_id] == nil || current_user != nil
      redirect_to root_path
    end
  end

  def create
    # verify passwords enter matchs and user update without errors, then auto sign in and redirect home
    if params[:user][:password_confirmation] == params[:user][:password] && current_or_guest_user.update(user_params)
      sign_in(current_or_guest_user)
      redirect_to root_path
    else render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name)
  end

end
