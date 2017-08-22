class ProposalsController < ApplicationController

  def new
    @choogle = Choogle.find(params[:choogle_id])
    @proposal = Proposal.new
  end

  def create
    @proposal = Proposal.new(proposal_params)
    if Place.find_by(params[:place]).nil?
      @place = Place.find_by(params(:place))
    else
      @place = Place.create.new(name: params[:place])
    end
    @proposal.place = @place
    @proposal.choogle = Choogle.find(params[:choogle_id])
    @proposal.save

    redirect_to choogle_path(params[:choogle_id])
  end

  private

  def proposal_params
    params.require(:proposal).permit()
  end
end
