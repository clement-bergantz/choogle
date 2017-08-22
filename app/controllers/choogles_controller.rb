class ChooglesController < ApplicationController
  def show
  end



  def new
    @choogle = Choogle.new
  end

  def create
    raise
    @user = current_user
    @choogle = @user.choogle.new(choogle_params)
    @choogle.slug = Faker::Number.number(10)
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
