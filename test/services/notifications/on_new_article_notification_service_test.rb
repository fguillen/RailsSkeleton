require "test_helper"

class Notifications::OnNewArticleNotificationServiceTest < ActiveSupport::TestCase
  def test_perform
    article = FactoryBot.create(:article)

    front_user_1 = FactoryBot.create(:front_user, notifications_active: ["on_new_article"])
    front_user_2 = FactoryBot.create(:front_user, notifications_active: ["on_new_article"])
    front_user_3 = FactoryBot.create(:front_user, notifications_active: [])
    front_user_4 = FactoryBot.create(:front_user, notifications_active: ["on_new_article"])
    article.update!(front_user: front_user_4) # author should not be notified

    admin_user_1 = FactoryBot.create(:admin_user, notifications_active: ["on_new_article"])
    admin_user_2 = FactoryBot.create(:admin_user, notifications_active: ["on_new_article"])
    admin_user_3 = FactoryBot.create(:admin_user, notifications_active: [])

    Notifications::Front::Mailer.expects(:on_new_article).with(front_user_1, article).returns(stub(deliver: nil))
    Notifications::Front::Mailer.expects(:on_new_article).with(front_user_2, article).returns(stub(deliver: nil))
    Notifications::Front::Mailer.expects(:on_new_article).with(front_user_3, article).never

    Notifications::Admin::Mailer.expects(:on_new_article).with(admin_user_1, article).returns(stub(deliver: nil))
    Notifications::Admin::Mailer.expects(:on_new_article).with(admin_user_2, article).returns(stub(deliver: nil))
    Notifications::Admin::Mailer.expects(:on_new_article).with(admin_user_3, article).never

    Notifications::OnNewArticleNotificationService.perform(article)
  end
end
