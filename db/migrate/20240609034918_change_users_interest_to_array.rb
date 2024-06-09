class ChangeUsersInterestToArray < ActiveRecord::Migration[7.1]
  def up
    change_column :users, :interests, :string, array: true, default: [], using: "(string_to_array(interests, ','))"
  end
end
