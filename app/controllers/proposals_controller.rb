class ProposalsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:new, :create]
    skip_before_filter :verify_authenticity_token, :only => [:new, :create]

  def new
    @choogle = Choogle.find_by_slug(params[:slug])
    @proposal = Proposal.new

    respond_to do |format|
      format.js
    end
  end

  def create
    @proposal = Proposal.new
    # We create a new client for the Google Places API
    # [PLACE]
    unless proposal_params["place"].blank?
      @client = GooglePlaces::Client.new(ENV['GOOGLE_API_SERVER_KEY'])
      # We get the Google Places Object matching user entry (e.g.: "La Vie Moderne, Bordeaux")
      place_info = @client.spots_by_query(proposal_params["place"])[0]
      if Place.find_by(api_google_id: place_info.place_id).nil?
        @place = Place.new(address: place_info.formatted_address)
        @place.name = place_info.name
        @place.rating = place_info.rating unless place_info.rating.nil?
        @place.api_google_id = place_info.place_id
        @place.save
      else
        @place = Place.find_by(api_google_id: place_info.place_id)
      end
    else
      @place = Place.new
    end
    @proposal.place = @place

    # [USER]
    # Update and save User timecode autofill with moment JS
    @user = current_or_guest_user
    @user.timecode = params["proposal"]["user"]["timecode"]
    @user.save
    # Check if user is guest
    unless user_signed_in? || @user.first_name != 'guest'
      @user.first_name = params["proposal"]["user"]["first_name"]
      @user.save
    end

    @proposal.user = @user

    @proposal.choogle = Choogle.find_by_slug(params[:slug])

    set_create_tags

    respond_to do |format|
      if @proposal.save
        @user.upvotes.new(proposal: @proposal).save
        format.js {render :js => "window.location.href='#{choogle_path}'"}
      else
        format.js {render "proposals/errors"}
        format.js {render "proposals/new"}
      end
    end
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
    params.require(:proposal).permit(:place, user: [:first_name, :timecode], tag_ids: [])
  end

end
