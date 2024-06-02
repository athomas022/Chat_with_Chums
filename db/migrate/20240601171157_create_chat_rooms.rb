class CreateChatRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_rooms do |t|
      t.string :name
      t.string :
      t.date :created_on
      t.string :personality_types
      t.string :chat_messages
      t.string :chat_users
      t.boolean :is_public
      t.text :announcements

      t.timestamps
    end
  end
end
