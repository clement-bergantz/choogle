class Proposal < ApplicationRecord
  belongs_to :choogle
  belongs_to :place
  belongs_to :user
  has_many :upvotes
  has_many :proposal_tags

  geocoded_by :place
  after_validation :geocode, if: :place_id_changed?

# Method to count upvotes for a Proposal Instance

  def upvotes
    Upvote.where(proposal: self).size
  end
end
