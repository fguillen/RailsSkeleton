# frozen_string_literal: true

class InitializeUserNotificationsPref < ActiveRecord::Migration[7.0]
  def up
    FrontUser.all.each do |front_user|
      front_user.create_user_notifications_pref! unless front_user.user_notifications_pref.present?
    end

    AdminUser.all.each do |admin_user|
      admin_user.create_user_notifications_pref! unless admin_user.user_notifications_pref.present?
    end
  end
end
