class Upvote < ApplicationRecord
  belongs_to :proposal
  belongs_to :user
  validates :user_id, uniqueness: { scope: :proposal_id }
end
