class ProposalsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @choogle = Choogle.find(params[:choogle_id])
    @proposal = Proposal.new
    @proposal.proposal_tags.build

    # This line is just for testing in the view
    @proposals = Proposal.all.last(3)

  end

  def create
    @proposal = Proposal.new
    # We create a new client for the Google Places API
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_SERVER_KEY'])
    # We get the Google Places Object matching user entry (e.g.: "La Vie Moderne, Bordeaux")
    place_info = @client.spots_by_query(proposal_params["place"])[0]
    # We are looking in the DB if the Object exists
    if Place.find_by(api_google_id: place_info.place_id).nil?
      # If it doesn't: let's create one!
      @place = Place.new(address: place_info.formatted_address)
      @place.name = place_info.name
      # We are getting the API id, which will be useful in the future the query Google about our own Places Objects.
      # Ex: if I want to fetch a Place rating on a "place" instance of Place
      @place.api_google_id = place_info.place_id
    else
      @place = Place.find_by(api_google_id: place_info.place_id)
    end
    @proposal.place = @place
    @proposal.user = current_user
    @proposal.choogle = Choogle.find(params[:choogle_id])
    @proposal.save
    # [TAGS]
    # Check if tag already exists
    if Tag.find_by(name: params[:proposal][:proposal_tags]["tags"]).nil?
      # If it doesn't, we create this tag with random color
      @tag = Tag.new(name: params[:proposal][:proposal_tags]["tags"], color: Faker::Color.hex_color)
      @tag.save
    else
      @tag = Tag.find_by(name: params[:proposal][:proposal_tags]["tags"])
    end
    @proposal_tags = ProposalTag.new(tag: @tag, proposal: @proposal)
    @proposal_tags.save

    redirect_to choogle_path(params[:choogle_id])
  end

  private

  def proposal_params
    params.require(:proposal).permit(:place)
  end

  def proposal_tags_params
    params.require(:proposal_tags).permit(:tags)
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
