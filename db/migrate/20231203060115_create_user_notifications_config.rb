class CreateUserNotificationsConfig < ActiveRecord::Migration[6.1]
  def change
    create_table :user_notifications_configs, id: false do |t|
      t.string :uuid, null: false, index: { unique: true }, primary_key: true
      t.json :active_notifications
      t.string  :user_id
      t.string  :user_type
      t.timestamps
    end

    add_index :user_notifications_configs, [:user_type, :user_id], unique: true
  end
end
