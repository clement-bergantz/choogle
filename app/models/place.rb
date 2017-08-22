class Place < ApplicationRecord
	has_many :proposals
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
