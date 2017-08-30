class ChatRoomsChannel < ApplicationCable::Channel
  def subscribed
    def subscribed
      stream_from "comment_#{comment.choogle.slug}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
