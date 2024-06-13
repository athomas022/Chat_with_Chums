
class Message < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :chat_room, class_name: 'ChatRoom', foreign_key: 'chat_room_id'

  after_create_commit :broadcast_message

  private

  def broadcast_message
    username = user&.username || 'Unknown User'
    ActionCable.server.broadcast("chat_room_#{chat_room.id}_channel", {
      id: id,
      body: body,
      user_id: user_id,
      username: username,
      message_html: render_message
    })
  end

  def render_message
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: self, current_user: user })
  end
 
end

