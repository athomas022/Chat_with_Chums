class ChangeChatMessagesInChatRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :chat_rooms, :messages_id, :integer
    remove_column :chat_rooms, :chat_messages, :string
  end
end
