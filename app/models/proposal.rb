class Proposal < ApplicationRecord
  belongs_to :choogle
  belongs_to :place
  belongs_to :user
  has_many :upvotes, dependent: :destroy
  has_many :proposal_tags, dependent: :destroy

  geocoded_by :place
  after_validation :geocode, if: :place_id_changed?

  def upvotes
    Upvote.where(proposal: self).size
  end
end
