class Proposal < ApplicationRecord
  belongs_to :choogle
  belongs_to :place
  belongs_to :user
  has_many :upvotes, dependent: :destroy
  has_many :proposal_tags, dependent: :destroy
  has_many :tags, through: :proposal_tags

  geocoded_by :place
  after_validation :geocode, if: :place_id_changed?

# Method to count upvotes for a Proposal Instance

  def upvotes_count
    upvotes.size
  end
end
