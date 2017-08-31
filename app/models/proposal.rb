class Proposal < ApplicationRecord
  belongs_to :choogle
  belongs_to :place
  belongs_to :user
  has_many :upvotes, dependent: :destroy
  has_many :proposal_tags, dependent: :destroy
  has_many :tags, through: :proposal_tags

  geocoded_by :place
  after_validation :geocode, if: :place_id_changed?

  scope :upvotes_count, -> {
    select('proposals.*, COUNT(upvote.proposal_id) AS upvotes_count')
    .joins(:upvotes)
    .group('proposals.id')
    .order('upvotes_count DESC')
  }




  Proposal.select("proposals.*, COUNT(upvotes.id) as upvote_count").group("proposals.id").order("upvote_count DESC")
end
