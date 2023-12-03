class AddNotificationsActiveToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :front_users, :notifications_active, :text
    add_column :admin_users, :notifications_active, :text
  end
end
