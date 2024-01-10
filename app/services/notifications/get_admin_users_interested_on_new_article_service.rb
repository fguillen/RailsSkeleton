class Notifications::GetAdminUsersInterestedOnNewArticleService < Service
  def perform
    admin_users = AdminUser.where("notifications_active like ?", "%on_new_article%")
    admin_users
  end
end
