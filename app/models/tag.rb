class Tag < ApplicationRecord
	has_many :proposal_tags
	validates :color, presence: true
	validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
end
