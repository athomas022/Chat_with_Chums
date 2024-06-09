class ChangeDescriptionInMessages < ActiveRecord::Migration[7.1]
  def change
    remove_column :messages, :description, :text
    add_column :messages, :body, :text
  end
end
