class ChangeInterestsToStringInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :interests, :string
  end
end
