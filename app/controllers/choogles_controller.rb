class ChooglesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :new, :create]


  def show
    # we find the choogle by its slug
    @choogle = Choogle.find_by_slug(params[:slug])

    places = @choogle.places

    @hash = Gmaps4rails.build_markers(places) do |place, marker|
      marker.lat place.latitude
      marker.lng place.longitude
      # // uncomment to add a specific marker
      # marker.picture({
      #   "url" => view_context.image_path("marker.png"),
      #   "width" => 64,
      #   "height" =>64
      # })

      # marker.infowindow render_to_string(partial: "/places/map_box", locals: { place: place })
    end
    @proposal = Proposal.new
    @user = current_or_guest_user
    @comment = Comment.new
    # @place = Place.find(params[:id])
    # @place_coordinates = { lat: @place.latitude, lng: @place.longitude }

  end

  def new
    @user = current_user
    @choogle = Choogle.new
    @proposal = Proposal.new
  end

  def create
    @user = current_or_guest_user
    # Check if we are creating a Choogle
    unless params["choogle"].nil?
      # If we are, let's create it!
      @choogle = @user.choogles.new(choogle_params)
      # we generate a random slug
      slug = SecureRandom.urlsafe_base64(5)
      # we check if the slug is not already persisted in the DB
      while Choogle.find_by(slug: slug)
      # when a similar slug is find (true), a new slug is generated
        slug = SecureRandom.urlsafe_base64(5)
      end
      # our choogle slug is now our previously generated slug
      @choogle.slug = slug
      # We already create the first proposal related to this new Choogle
      @choogle.save
    else
      # Nothing in the params indicating we're creating a Choogle.
      # Means we are creating the first proposal !
      # We want to retrieve it by looking at our user last proposal.
      @proposal = Proposal.new
      # [PLACE]
      # Looking in the DB if we already have this place
      @client = GooglePlaces::Client.new(ENV['GOOGLE_API_SERVER_KEY'])
      # We get the Google Places Object matching user entry (e.g.: "La Vie Moderne, Bordeaux")
      place_info = @client.spots_by_query(params["proposal"]["place"])[0]
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
      @proposal.place = @place
      @proposal.choogle = @user.choogles.last
      @proposal.user = @user
      @proposal.proposal_tags << @proposal_tags
      @proposal.save
      redirect_to choogle_path(@proposal.choogle)
    end
  end

private

  def choogle_params
      params.require(:choogle).permit(:title, :due_at, :happens_at)
  end

  def proposal_params
  end

end
