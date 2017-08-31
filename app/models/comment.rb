class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :choogle
  validates :content, presence: true, length: {maximum: 2000}
  after_save :broadcast_comment

  def broadcast_comment
    # looking for all clients on the broadcast and push comments size and proposal id
    ActionCable.server.broadcast(
    "chat_rooms_#{choogle.slug}", {
      message_partial: ApplicationController.renderer.render(
              partial: "comments/comment",
              locals: { comment: self }
            ),
      current_user_id: user.id
    })
  end
end
