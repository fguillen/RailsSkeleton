class CreateFrontUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :front_users, id: false do |t|
      t.string :uuid, null: false, index: { unique: true }, primary_key: true
      t.string :name, null: false
      t.string :email, null: false

      t.string :crypted_password
      t.string :password_salt
      t.string :perishable_token, index: { unique: true }
      t.string :persistence_token, index: { unique: true }

      t.timestamps
    end
  end
end
