class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream from "chat_room_#{params[:chat_room_id]}"
  end

  def unsubscribed
  end
end
