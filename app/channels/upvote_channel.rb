class UpvoteChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    # name of the WS channel for new subscribers
    stream_from "upvote_#{params[:choogle_slug]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
