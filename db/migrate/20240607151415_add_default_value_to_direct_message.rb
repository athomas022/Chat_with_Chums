class AddDefaultValueToDirectMessage < ActiveRecord::Migration[7.1]
  def change
    change_column_default :chat_rooms, :direct_message, 'false'
  end
end
