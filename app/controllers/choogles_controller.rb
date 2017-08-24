class ChooglesController < ApplicationController

  def show
    @choogle = Choogle.find(params[:id])

    places = @choogle.places

    @hash = Gmaps4rails.build_markers(places) do |place, marker|
      marker.lat place.latitude
      marker.lng place.longitude
      marker.picture({
        "url" => view_context.image_path('rocket_pointer.png'),
        "width" => 64,
        "height" => 64
      })

    @proposal = Proposal.new
      # marker.infowindow render_to_string(partial: "/places/map_box", locals: { place: place })
    end
    # @place = Place.find(params[:id])
    # @place_coordinates = { lat: @place.latitude, lng: @place.longitude }

  end

  def new
    @choogle = Choogle.new
    @proposal = Proposal.new
  end

  def create
    @user = current_user
    unless params["choogle"]["title"].nil?
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
      @proposal = Proposal.new
      @choogle.save
      @proposal.choogle = @choogle
      @proposal.user = @user
      @proposal.place = Place.last
      @proposal.save
    else
      @proposal = current_user.proposals.last
      if Place.find_by(name: params["choogle"]["proposal"]["place"]).nil?
        # If it doesn't: let's create one!
        @place = Place.new(name: params["choogle"]["proposal"]["place"])
        # We are getting the API id, which will be useful in the future the query Google about our own Places Objects.
        # Ex: if I want to fetch a Place rating on a "place" instance of Place
      else
        @place = Place.find_by(name: params["choogle"]["proposal"]["place"])
      end
      @proposal.place = @place
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
