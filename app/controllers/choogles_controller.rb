class ChooglesController < ApplicationController
  def show
  end

  def new
    @choogle = Choogle.new
  end

  def create
    @user = current_user
    @choogle = @user.choogles.new(choogle_params)
    @choogle.slug = Faker::Number.number(10)
         raise
    if @choogle.save
      redirect_to choogle_proposals_path(@choogle)
    else
      render "choogles/new"
    end
  end

private

  def choogle_params
      params.require(:choogle).permit(:title, :due_at, :happens_at)
  end

end
