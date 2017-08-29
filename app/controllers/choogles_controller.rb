class ChooglesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :new, :create]

  def show
    # we find the choogle by its slug
    @choogle = Choogle.find_by_slug(params[:slug])
    @user = current_or_guest_user
    @proposal = Proposal.new
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
    @comments = Comment.where(choogle: @choogle).order('created_at DESC').first(5)
    # @place = Place.find(params[:id])
    # @place_coordinates = { lat: @place.latitude, lng: @place.longitude }

    @notification = Notification.new

    respond_to do |format|
      format.html
      format.js
    end

  end

  def new
    @user = current_or_guest_user
    @choogle = Choogle.new
    @proposal = Proposal.new
    @proposal.choogle = @choogle
  end

  def create
    @choogle = current_or_guest_user.choogles.new(choogle_params)
    @choogle.save

    @proposal = @choogle.proposals.new

    respond_to do |format|
      format.js { render "proposals/new" }
    end
  end

private

  def choogle_params
      params.require(:choogle).permit(:title, :due_at, :happens_at)
  end
end
