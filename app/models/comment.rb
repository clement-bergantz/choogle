class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :choogle
  validates :content, presence: true, length: {maximum: 2000}
end
