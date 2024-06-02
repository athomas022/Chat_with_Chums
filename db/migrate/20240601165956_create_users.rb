class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :name
      t.integer :age
      t.binary :picture
      t.integer :zipcode
      t.string :personality_type
      t.string :interests
      t.boolean :is_verified
      t.string :chat_groups
      t.string :user_messages
      t.string :user_friends 
      t.boolean :is_online
      t.text :bio

      t.timestamps
    end
  end
end
