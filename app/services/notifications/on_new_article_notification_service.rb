class Notifications::OnNewArticleNotificationService < Service
  def perform(article)
    front_users = Notifications::OnNewArticleGetFrontUsersInterestedService.perform
    front_users.each do |front_user|
      if front_user != article.front_user # Doesn't notify the author
        Notifications::Front::Mailer.on_new_article(front_user, article)
      end
    end

    admin_users = Notifications::OnNewArticleGetAdminUsersInterestedService.perform
    admin_users.each do |admin_user|
      Notifications::Admin::Mailer.on_new_article(admin_user, article)
    end
  end
end
