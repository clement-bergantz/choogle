class UpvotesController < ApplicationController

  def create
    @proposal = Proposal.find(params[:id])
    @upvote = current_user.upvotes.new(proposal: @proposal)
    @choogle = Choogle.find_by_slug(params[:slug])
    if @upvote.save
      redirect_to choogle_path(@choogle)
    else
      # Flash message to alert user if he already vote
      flash[:upvote] = 'You already votes for this proposal !'
      redirect_to choogle_path(@choogle)
    end
  end

end
