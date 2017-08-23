class UpvotesController < ApplicationController

  def create

    @proposal = Proposal.find(params[:id])
    @choogle = Choogle.find_by_slug(params[:slug])

    # Searching in DB if the upvote for this user and proposal exist, if not,
    if current_user.upvotes.find_by(proposal: @proposal).nil?
      @upvote = current_or_guest_user.upvotes.new(proposal: @proposal)
      # Saving it and respond to Ajax request in JS, else render error in console with create.js.erb
      if @upvote.save
        respond_to do |format|
          format.html { redirect_to choogle_path(@choogle) }
          format.js  # <-- will render `app/views/upvotes/create.js.erb`
        end
      else
        respond_to do |format|
          format.html { redirect_to choogle_path(@choogle) }
          format.js  # <-- idem
        end
      end
    # Searching in DB if the upvote for this user and proposal exist,
    else current_user.upvotes.find_by(proposal: @proposal)
      @upvote = current_or_guest_user.upvotes.find_by(proposal: @proposal)
      # Destroying it and respond to Ajax request in JS, else render error in console with create.js.erb
      if @upvote.destroy
        respond_to do |format|
          format.html { redirect_to choogle_path(@choogle) }
          format.js  # <-- will render `app/views/upvotes/create.js.erb`
        end
      else
        respond_to do |format|
          format.html { redirect_to choogle_path(@choogle) }
          format.js  # <-- idem
        end
      end
    end
  end

end
