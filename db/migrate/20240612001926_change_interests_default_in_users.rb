class ChangeInterestsDefaultInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :interests, from: nil, to: []
  end
end
