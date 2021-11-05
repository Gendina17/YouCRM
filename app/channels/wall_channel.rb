class WallChannel < ApplicationCable::Channel
  def subscribed
    stream_from "wall_#{params[:company]}"
  end
end
