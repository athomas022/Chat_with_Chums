class AddMessagesIdAndUsersIdAsArrayToChatRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :chat_rooms, :messages_id, :integer, array: true, default: []
    add_column :chat_rooms, :users_id, :integer, array: true, default: []
  end
end
