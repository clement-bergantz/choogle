class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name])
  end


 # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_user(with_retry = false).try(:reload)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user if with_retry
  end

  private

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    # For example:
    # guest_comments = guest_user.comments.all
    # guest_comments.each do |comment|
      # comment.user_id = current_user.id
      # comment.save!
    # end
  end

  def avatars
    [
      "http://icon-icons.com/icons2/1070/PNG/512/ewok_icon-icons.com_76943.png",
      "http://icon-icons.com/icons2/1070/PNG/512/admiral-ackbar_icon-icons.com_76935.png",
      "http://icon-icons.com/icons2/1070/PNG/512/qui-gon-jinn_icon-icons.com_76946.png",
      "https://www.shareicon.net/download/2016/11/21/854798_raider_327x512.png",
      "http://icon-icons.com/icons2/1070/PNG/512/luke-skywalker_icon-icons.com_76939.png",
      "http://icon-icons.com/icons2/1070/PNG/512/yoda_icon-icons.com_76947.png",
      "http://www.iconninja.com/files/632/403/650/princess-leia-icon.svg",
      "https://www.shareicon.net/download/2016/11/21/854777_darth_410x512.png",
      "https://www.shareicon.net/download/2016/11/21/854773_c3p0_432x512.png",
      "http://icon-icons.com/icons2/1070/PNG/512/jawa_icon-icons.com_76960.png",
      "http://www.iconninja.com/files/301/550/552/jabba-the-hutt-icon.svg",
      "http://icon-icons.com/icons2/1070/PNG/512/chewbacca_icon-icons.com_76942.png",
    ]
  end

  def create_guest_user
    u = User.create(
      :first_name => "guest",
      :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com",
      :facebook_picture_url => avatars.sample
      )
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end
end
