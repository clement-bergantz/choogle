class ProposalsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:new, :create]
    skip_before_filter :verify_authenticity_token, :only => [:new, :create]

  def new
    # we search the choogle by its slug
    @choogle = Choogle.find_by_slug(params[:choogle_id])
    @proposal = Proposal.new

    # This line is just for testing in the view
    @proposals = Proposal.all.last(3)
    @user = current_or_guest_user
  end

  def create
    @proposal = Proposal.new
    # We create a new client for the Google Places API
    # [PLACE]
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
    # [USER]
    @user = current_or_guest_user
    # Check if user is guest
    unless user_signed_in?
      @user.first_name = params["proposal"]["user"]["first_name"]
      @user.save
    end
    @proposal.user = @user
    # We search the Choogle by its slug
    @proposal.choogle = Choogle.find_by_slug(params[:choogle_id])

    set_create_tags
    @proposal.save

    redirect_to choogle_path(params[:choogle_id])
  end

  # Select2 return names of tags in params
  def set_create_tags
    unless proposal_params[:tag_ids].nil?
      # Select2 return a first blank tag, we reject it
      tags = proposal_params[:tag_ids].reject { |tag_id| tag_id.blank? }

      # We have a list of tags, for each we create an instance with a color and find
      # if it exists or not, if yes it will not be created, if yes it is created
      # after all tags, new and finded are pushed in @proposal.tags which is saved in create method
      tags.each do |tag_name|

        # Official doc : Find the first user named "Scarlett" or create a new one with
        # a particular last name.
        #User.create_with(last_name: 'Johansson').find_or_create_by(first_name: 'Scarlett')

        tag = Tag.create_with(color: Faker::Color.hex_color).find_or_create_by(name: tag_name)
        @proposal.tags << tag
      end
    end
  end

  private

  def proposal_params
    # Strongs params need to be specify if array
    params.require(:proposal).permit(:place, tag_ids: [])
  end

end
