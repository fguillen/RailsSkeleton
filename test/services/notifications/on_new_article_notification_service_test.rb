require "test_helper"

class Notifications::OnNewArticleNotificationServiceTest < ActiveSupport::TestCase
  def test_perform
    article = FactoryBot.create(:article)

    front_user_1 = FactoryBot.create(:front_user, notifications_active: ["on_new_article"])
    front_user_2 = FactoryBot.create(:front_user, notifications_active: ["on_new_article"])
    front_user_3 = FactoryBot.create(:front_user, notifications_active: [])

    admin_user_1 = FactoryBot.create(:admin_user, notifications_active: ["on_new_article"])
    admin_user_2 = FactoryBot.create(:admin_user, notifications_active: ["on_new_article"])
    admin_user_3 = FactoryBot.create(:admin_user, notifications_active: [])

    Notifications::Front::Mailer.expects(:on_new_article).with(front_user_1, article)
    Notifications::Front::Mailer.expects(:on_new_article).with(front_user_2, article)
    Notifications::Front::Mailer.expects(:on_new_article).with(front_user_3, article).never

    Notifications::Admin::Mailer.expects(:on_new_article).with(admin_user_1, article)
    Notifications::Admin::Mailer.expects(:on_new_article).with(admin_user_2, article)
    Notifications::Admin::Mailer.expects(:on_new_article).with(admin_user_3, article).never

    Notifications::OnNewArticleNotificationService.perform(article)
  end
end
