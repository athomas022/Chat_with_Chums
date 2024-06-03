class ChangeCreatedByInMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :user_id, :integer
    remove_column :messages, :created_by, :string
  end
end
