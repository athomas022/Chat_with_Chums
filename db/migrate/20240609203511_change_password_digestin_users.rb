class ChangePasswordDigestinUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :password_digest, :string
    add_column :users, :password, :string
  end
end
