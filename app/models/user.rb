class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  has_many :notifications, dependent: :destroy
  has_many :choogles, dependent: :destroy
  has_many :upvotes, dependent: :destroy
  has_many :proposals, dependent: :destroy
  has_many :comments, dependent: :destroy
  # With this and has_many tags on proposal we can call user.tags
  # to get all the tags used by a user on his proposals.
  has_many :tags, through: :proposals
  validates :first_name, presence: true

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
      user.password = Devise.friendly_token[0, 20] # Fake password for validate
      user.save
    end

    user
  end

  def remove_duplicates(array)
    response = []
    array.each do |tag|
      response << tag unless response.include?(tag)
    end
    response
  end

  def is_guest?
    first_name.nil? || first_name == "guest" || first_name.empty?
  end

  # This is used to get all tags of the instance of user
  def tags
    usertags = []
    proposals.each do |proposal|
      usertags << proposal.tags.map(&:name) unless usertags.include?(proposal.tags.map(&:name))
    end
    remove_duplicates(usertags.flatten)
  end
end
