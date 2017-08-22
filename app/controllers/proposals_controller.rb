class ProposalsController < ApplicationController

  def new
    @choogle = Choogle.find(params[:choogle_id])
    @proposal = Proposal.new
  end

  def create
    @proposal = Proposal.new
    if Place.find_by(address: proposal_params["place"]).nil?
      @place = Place.new(address: proposal_params["place"])
    else
      @place = Place.find_by(address: proposal_params["place"])
    end
    @proposal.place = @place
    @proposal.user = current_user
    @proposal.choogle = Choogle.find(params[:choogle_id])
    @proposal.save

    redirect_to choogle_path(params[:choogle_id])
  end

  private

  def proposal_params
    params.require(:proposal).permit(:place)
  end
end
