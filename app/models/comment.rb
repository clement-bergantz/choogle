class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :choogle
  validates :content, presence: true, length: {maximum: 2000}
  after_save :broadcast_comment

  def broadcast_comment
    # looking for all clients on the broadcast and push comments size and proposal id
    ActionCable.server.broadcast(
    "chat_room_#{choogle.slug}",
    comment: self,
    )
  end
end
