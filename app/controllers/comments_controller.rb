class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  skip_before_filter :verify_authenticity_token, :only => [:new, :create]

  def create
    @comment = Comment.new(content: comment_params[:content])
    @user = current_or_guest_user

    unless user_signed_in? || current_or_guest_user.first_name != 'guest'
      @user.first_name = comment_params["user"]["first_name"]
      @user.save
    end

    @comment.user = @user
    choogle = Choogle.find_by(slug: params[:slug])
    @comment.choogle = choogle

    if current_or_guest_user.first_name.empty?
      respond_to do |format|
        format.js {render "comments/errors"}
      end
    elsif @comment.save
      respond_to do |format|
        format.html {redirect_to choogle_path(params[:slug])}
        format.js {render "comments/create"}
      end
    end
  end

  private

  def comment_params
      params.require(:comment).permit(:content, {:user => [:first_name]})
  end
end
