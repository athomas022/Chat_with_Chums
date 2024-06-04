class AddUserMessagesIdAndChatRoomsIdAndFriendsIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :user_messages_id, :integer, array: true, default: []
    add_column :users, :chat_rooms_id, :integer, array: true, default: []
    add_column :users, :friends_id, :integer, array: true, default: []
  end
end
