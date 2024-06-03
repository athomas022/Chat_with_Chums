class RemoveChatRoomsFromMessages < ActiveRecord::Migration[7.1]
  def change
    remove_column :messages, :chat_rooms, :string
  end
end
