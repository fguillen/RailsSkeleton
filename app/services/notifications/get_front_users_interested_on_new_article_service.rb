class Notifications::GetFrontUsersInterestedOnNewArticleService < Service
  def perform
    front_users = FrontUser.where("notifications_active like ?", "%on_new_article%")
    front_users
  end
end
