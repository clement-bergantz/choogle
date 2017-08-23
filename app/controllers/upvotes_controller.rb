class UpvotesController < ApplicationController

  def create

    @proposal = Proposal.find(params[:id])
    @upvote = current_user.upvotes.new(proposal: @proposal)
    @choogle = Choogle.find_by_slug(params[:slug])
    if @upvote.save
        respond_to do |format|
          format.html { redirect_to choogle_path(@choogle) }
          format.js  # <-- will render `app/views/upvotes/create.js.erb`
        end
    else
      # Flash message to alert user if he already vote
      # flash[:upvote] = 'You already votes for this proposal !'
        respond_to do |format|
          format.html { redirect_to choogle_path(@choogle) }
          format.js  # <-- idem
        end
    end
  end

end
