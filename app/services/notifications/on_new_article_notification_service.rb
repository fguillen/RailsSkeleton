class Notifications::OnNewArticleNotificationService < Service
  def perform(article)
    front_users = Notifications::GetFrontUsersInterestedOnNewArticleService.perform

    front_users.each do |front_user|
      Notifications::Front::Mailer.on_new_article(front_user, article)
    end

    admin_users = Notifications::GetAdminUsersInterestedOnNewArticleService.perform

    admin_users.each do |admin_user|
      Notifications::Admin::Mailer.on_new_article(admin_user, article)
    end
  end
end
