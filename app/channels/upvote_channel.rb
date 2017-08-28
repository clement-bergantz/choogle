class UpvoteChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "upvote_#{params[:choogle_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
