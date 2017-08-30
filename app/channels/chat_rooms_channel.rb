class ChatRoomsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_rooms_#{params[:choogle_slug]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
