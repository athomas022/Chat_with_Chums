class ChangeChatUsersInChatRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :chat_rooms, :users_id, :integer
    remove_column :chat_rooms, :chat_users, :string
  end
end
