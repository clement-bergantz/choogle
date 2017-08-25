class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  skip_before_filter :verify_authenticity_token, :only => [:new, :create]

  def create
    @comment = Comment.new(comment_params)
    @user = current_or_guest_user
    @comment.user = @user
    choogle = Choogle.find_by(slug: params[:slug])
    @comment.choogle = choogle
    respond_to do |format|
      if @user
        # @comment = @user.comments.build(comment_params)
        if @comment.save
          flash.now[:success] = 'Your comment was successfully posted!'
        else
          flash.now[:error] = 'Your comment cannot be saved.'
        end
        format.html {redirect_to choogle_path(@choogle)}
        format.js
      else
        format.html {redirect_to choogle_path(@choogle)}
        format.js {render nothing: true}
      end
    end
  end

  private

  def comment_params
      params.require(:comment).permit(:content)
  end
end
