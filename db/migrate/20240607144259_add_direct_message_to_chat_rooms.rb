class AddDirectMessageToChatRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :chat_rooms, :direct_message, :boolean
  end
end
