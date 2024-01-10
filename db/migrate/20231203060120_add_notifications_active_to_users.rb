class AddNotificationsActiveToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :front_users, :notifications_active, :json
    add_column :admin_users, :notifications_active, :json
  end
end
