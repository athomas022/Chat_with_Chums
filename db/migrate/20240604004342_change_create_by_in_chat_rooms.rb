class ChangeCreateByInChatRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :chat_rooms, :admin_id, :integer
    remove_column :chat_rooms, :create_by, :string
  end
end
