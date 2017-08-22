class Place < ApplicationRecord
	has_many :proposals
  has_many :choogle, through: :proposals
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
