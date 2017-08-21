class Proposal < ApplicationRecord
  belongs_to :choogle
  belongs_to :place
  belongs_to :user
end
