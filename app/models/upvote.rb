class Upvote < ApplicationRecord
  belongs_to :proposal
  belongs_to :user
  validates :user_id, uniqueness: { scope: :proposal_id }
  after_save :broadcast
  after_destroy :broadcast

  def broadcast
    ActionCable.server.broadcast(
    "upvote_#{proposal.choogle.slug}",
    upvotes: proposal.upvotes.size,
    proposal_id: proposal.id,
    )
  end
end
