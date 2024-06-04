class RemoveChatGroupsAndUserMessagesAndUserFriendsFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :chat_groups, :string
    remove_column :users, :user_messages, :string
    remove_column :users, :user_friends, :string
  end
end
