class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username, null: false
      t.string :password_digest
      t.string :password
      t.datetime :last_active_at

      t.timestamps
    end
  end
end
