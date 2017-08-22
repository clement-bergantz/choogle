class ChooglesController < ApplicationController

  def show
    @choogle = Choogle.find(params[:id])
    @places = Place.where.not(latitude: nil, longitude: nil)

    @hash = Gmaps4rails.build_markers(@places) do |place, marker|
      marker.lat place.latitude
      marker.lng place.longitude
      # marker.infowindow render_to_string(partial: "/places/map_box", locals: { place: place })
    end
    # @place = Place.find(params[:id])
    # @place_coordinates = { lat: @place.latitude, lng: @place.longitude }
  end

  def new
    @choogle = Choogle.new
  end

  def create
    @user = current_user
    @choogle = @user.choogles.new(choogle_params)
    @choogle.slug = Faker::Number.number(10)
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
