class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :logo
      t.integer :max_users, null: false
      t.string :hash_code
      t.string :image_background
      t.references :user, null: false, foreign_key: true
      t.boolean :visibility, default: false

      t.timestamps
    end
  end
end
