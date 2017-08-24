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
    # @place = Place.find(params[:id])
    # @place_coordinates = { lat: @place.latitude, lng: @place.longitude }

    @notification = Notification.new

  end

  def new
    @choogle = Choogle.new
  end

  def create
    @user = current_or_guest_user
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

    if @choogle.save
      redirect_to new_choogle_proposal_path(@choogle)
    else
      render "choogles/new"
    end
  end

private

  def choogle_params
      params.require(:choogle).permit(:title, :due_at, :happens_at)
  end

end
