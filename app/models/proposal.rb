class Proposal < ApplicationRecord
  belongs_to :choogle
  belongs_to :place
  belongs_to :user
  has_many :upvotes, dependent: :destroy
  has_many :proposal_tags, dependent: :destroy
  has_many :tags, through: :proposal_tags

  validate :guest_cant_propose, :proposal_must_have_place

  geocoded_by :place
  after_validation :geocode, if: :place_id_changed?

  scope :upvotes_count, -> {
    select('proposals.*, COUNT(upvote.proposal_id) AS upvotes_count')
    .joins(:upvotes)
    .group('proposals.id')
    .order('upvotes_count DESC')
  }

  scope :by_upvotes, -> { joins(:upvotes).group("proposals.id").order("COUNT(upvotes) DESC") }
  scope :most_upvoted, -> { by_upvotes.first }

  def upvoters
    self.upvotes.map(&:user).map(&:first_name)
  end

  def guest_cant_propose
    errors.add(:base, "Please add your name") if user.first_name == "guest" || user.first_name.nil? || user.first_name.empty?
  end

  def proposal_must_have_place
    errors.add(:base, "Please add a place") if place_id.nil?
  end
end
