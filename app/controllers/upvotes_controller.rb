class UpvotesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create

    if current_or_guest_user.first_name == "guest"
      @proposal = Proposal.find(params[:id])
      @user = current_or_guest_user

      respond_to do |format|
        format.js
      end
    else
      @proposal = Proposal.find(params[:id])
      @choogle = Choogle.find_by_slug(params[:slug])

      if current_or_guest_user.upvotes.find_by(proposal: @proposal).nil?
        @upvote = current_or_guest_user.upvotes.new(proposal: @proposal)

        respond_to do |format|
          if @upvote.save
            format.html { redirect_to choogle_path(@choogle) }
            format.js
          end
        end
      else current_or_guest_user.upvotes.find_by(proposal: @proposal)
        @upvote = current_or_guest_user.upvotes.find_by(proposal: @proposal)
        @upvote.destroy

        respond_to do |format|
          format.html { redirect_to choogle_path(@choogle) }
          format.js
        end
      end
    end
  end
end
