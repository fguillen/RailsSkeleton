require "test_helper"

class Notifications::OnNewArticleGetAdminUsersInterestedServiceTest < ActiveSupport::TestCase
  def test_perform
    NotificationsRoles.expects(:for_role).with("admin").at_least_once.returns(["on_new_article"])

    admin_user_1 = FactoryBot.create(:admin_user, notifications_active: ["on_new_article"])
    admin_user_2 = FactoryBot.create(:admin_user, notifications_active: ["on_new_article"])
    admin_user_3 = FactoryBot.create(:admin_user, notifications_active: [])

    admin_users = Notifications::OnNewArticleGetAdminUsersInterestedService.perform

    assert_primary_keys([admin_user_1, admin_user_2], admin_users, true)
  end
end
