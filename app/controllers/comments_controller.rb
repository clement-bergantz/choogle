class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  skip_before_filter :verify_authenticity_token, :only => [:new, :create]

  def create
    @comment = Comment.new
    @comment.user = current_or_guest_user
    binding.pry
    @comment.save
  end
end
