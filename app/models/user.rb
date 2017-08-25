class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  has_many :notifications
  has_many :choogles
  has_many :upvotes
  has_many :proposals
  has_many :comments
  # With this and has_many tags on proposal we can call user.tags
  # to get all the tags used by a user on his proposals.
  has_many :tags, through: :proposals

  def self.find_for_facebook_oauth(auth)
    user_params = auth.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    user_params = user_params.to_h

    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
    end

    return user
  end

  AVATARS = [
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
