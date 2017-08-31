class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  skip_before_filter :verify_authenticity_token, :only => [:new, :create]

  def create
    @comment = Comment.new(content: comment_params[:content])
    @user = current_or_guest_user

    unless user_signed_in?
      @user.first_name = comment_params["user"]["first_name"]
      @user.save
    end

    @comment.user = @user
    choogle = Choogle.find_by(slug: params[:slug])
    @comment.choogle = choogle
    @comment.save
    respond_to do |format|
      format.html {redirect_to choogle_path(params[:slug])}
      format.js
    end
  end

  private

  def comment_params
      params.require(:comment).permit(:content, {:user => [:first_name]})
  end
end
