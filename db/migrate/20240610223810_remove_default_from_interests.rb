class RemoveDefaultFromInterests < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :interests, nil
  end
end
