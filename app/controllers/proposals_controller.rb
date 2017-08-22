class ProposalsController < ApplicationController

  def new
    @choogle = Choogle.find(params[:choogle_id])
    @proposal = Proposal.new
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
      @place = Place.new(address: place_info.address_components)
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

    redirect_to choogle_path(params[:choogle_id])
  end

  private

  def proposal_params
    params.require(:proposal).permit(:place)
  end
end
