class Upvote < ApplicationRecord
  belongs_to :proposal
  belongs_to :user
  validates :user_id, uniqueness: { scope: :proposal_id }
  # Everything behind is for WS, at each save or destroy refresh on all clients
  after_save :broadcast_upvotes
  after_destroy :broadcast_upvotes

  def broadcast_upvotes
    # looking for all clients on the broadcast and push upvotes size and proposal id
    ActionCable.server.broadcast(
    "upvote_#{proposal.choogle.slug}",
    upvotes: self.proposal.upvotes.size,
    proposal_id: self.proposal.id,
    )
  end
end
