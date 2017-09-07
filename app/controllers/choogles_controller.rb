class ChooglesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :new, :create]

  def show
    # we find the choogle by its slug
    @choogle = Choogle.find_by_slug(params[:slug])
    @user = current_or_guest_user
    @proposal = Proposal.new
    proposals = @choogle.proposals

    if @choogle.due_at - 1.seconds < Time.zone.now
      proposals = [proposals.most_upvoted]
    end

    @hash = Gmaps4rails.build_markers(proposals) do |proposal, marker|
      marker.lat proposal.place.latitude
      marker.lng proposal.place.longitude
      marker.json({ :id => proposal.id, :address => proposal.place.address, :country => proposal.place.country })
      marker.infowindow render_to_string(partial: "/proposals/map_box", locals: { proposal: proposal })
    end
    @user = current_or_guest_user
    @comment = Comment.new
    @comments = Comment.where(choogle: @choogle).order('created_at')
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
    respond_to do |format|
      if @choogle.save
        @proposal = @choogle.proposals.new
        format.js { render "proposals/new" }
      else
        format.js { render "choogles/errors" }
      end
    end
  end

private

  def choogle_params
      params.require(:choogle).permit(:title, :due_at, :happens_at)
  end
end
