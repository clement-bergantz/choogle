class UpvotesController < ApplicationController

  def create
    @proposal = Proposal.find(params[:id])
    @upvote = current_user.upvotes.new(proposal: @proposal)
    @choogle = Choogle.find_by_slug(params[:slug])
    if @upvote.save
      redirect_to choogle_path(@choogle)
    else
      # ici l'erreur si le user a déjà voté ?
      render "choogles/new"
    end
  end

end
