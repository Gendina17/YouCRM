class WallChannel < ApplicationCable::Channel
  def subscribed
    stream_from "wall_channel"
  end
end
