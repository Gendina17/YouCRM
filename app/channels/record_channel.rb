class RecordChannel < ApplicationCable::Channel
  def subscribed
    stream_from "record_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
