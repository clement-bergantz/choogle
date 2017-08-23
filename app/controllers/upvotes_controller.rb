class UpvotesController < ApplicationController

  def create
    @proposal = Proposal.find(params[:proposal_id])
    @upvote = current_user.upvotes.new(proposal: @proposal)
    if @upvote.save
      redirect_to new_upvote_proposal_path(@upvote)
    else
      render "choogles/new"
    end

  end

private

# pas top... comment faire autrement ?
end
