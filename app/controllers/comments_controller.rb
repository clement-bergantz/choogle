class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  skip_before_filter :verify_authenticity_token, :only => [:new, :create]

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_or_guest_user
    choogle = Choogle.find_by(slug: params[:slug])
    @comment.choogle = choogle
    @comment.save
    redirect_to choogle_path(choogle)
  end

  private

  def comment_params
      params.require(:comment).permit(:content)
  end
end
