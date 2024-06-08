class ChangePictureDataTypeInUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :picture, :binary
    add_column :users, :picture, :string
  end
end
