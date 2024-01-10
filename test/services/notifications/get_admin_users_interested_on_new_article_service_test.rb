require "test_helper"

class Notifications::GetAdminUsersInterestedOnNewArticleServiceTest < ActiveSupport::TestCase
  def test_perform
    admin_user_1 = FactoryBot.create(:admin_user, notifications_active: ["on_new_article"])
    admin_user_2 = FactoryBot.create(:admin_user, notifications_active: ["on_new_article"])
    admin_user_3 = FactoryBot.create(:admin_user, notifications_active: [])

    admin_users = Notifications::GetAdminUsersInterestedOnNewArticleService.perform

    assert_primary_keys([admin_user_1, admin_user_2], admin_users, true)
  end
end
