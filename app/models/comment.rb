class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :choogle
  validates :content, presence: true, length: {maximum: 2000}
  after_save :broadcast_comments
  after_destroy :broadcast_comments

  def broadcast_comments
    # looking for all clients on the broadcast and push comments size and proposal id
    ActionCable.server.broadcast(
    "upvote_#{proposal.choogle.slug}",
    upvotes: proposal.upvotes.size,
    proposal_id: proposal.id,
    )
  end
end
