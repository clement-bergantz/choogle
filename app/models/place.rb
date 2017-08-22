class Place < ApplicationRecord
	has_many :proposals
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  def placify
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_SERVER_KEY'])
    @client.spot(self.api_google_id)
  end
end
