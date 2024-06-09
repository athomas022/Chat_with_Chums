class CreatePersonalities < ActiveRecord::Migration[7.1]
  def change
    create_table :personalities do |t|
      t.string :name
      t.string :interests, default: [], array: true
      t.string :compatible_personalities, default: [], array: true

      t.timestamps
    end
  end
end
