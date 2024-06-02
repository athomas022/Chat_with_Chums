class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :description
      t.string :created_by
      t.datetime :time_stamp
      t.string :chat_rooms

      t.timestamps
    end
  end
end
