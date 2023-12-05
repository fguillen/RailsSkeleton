# frozen_string_literal: true

class InitializeUserNotificationsConfig < ActiveRecord::Migration[7.0]
  def up
    FrontUser.all.each do |front_user|
      front_user.create_user_notifications_config! unless front_user.user_notifications_config.present?
    end

    AdminUser.all.each do |admin_user|
      admin_user.create_user_notifications_config! unless admin_user.user_notifications_config.present?
    end
  end
end
