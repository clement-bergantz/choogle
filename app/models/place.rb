class Place < ApplicationRecord
	has_many :proposals
  has_many :choogles, through: :proposals
  geocoded_by :address

  validates :api_google_id, presence: true

  after_validation :geocode, if: :address_changed?
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.country = geo.country
    end
  end
  after_validation :fetch_address

  def placify
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_SERVER_KEY'])
    @client.spot(self.api_google_id)
  end

  def rating_round
    self.rating.round unless self.rating.nil?
  end
end
