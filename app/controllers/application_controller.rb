class ApplicationController < ActionController::Base
  # config.action_view.embed_authenticity_token_in_remote_forms = true
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  add_flash_types :upvote
end
