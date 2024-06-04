class RemoveMessagesIdAndUsersIdInChatRooms < ActiveRecord::Migration[7.1]
  def change
    remove_column :chat_rooms, :messages_id
    remove_column :chat_rooms, :users_id
  end
end
