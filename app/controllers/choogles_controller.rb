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
      # marker.infowindow render_to_string(partial: "/places/map_box", locals: { place: place })
    end
    # @place = Place.find(params[:id])
    # @place_coordinates = { lat: @place.latitude, lng: @place.longitude }
  end
end
