class ProposalTag < ApplicationRecord
  belongs_to :tag
  belongs_to :proposal
end
