require "test_helper"

class Notifications::OnNewArticleGetFrontUsersInterestedServiceTest < ActiveSupport::TestCase
  def test_perform
    NotificationsRoles.expects(:for_role).with("front").at_least_once.returns(["on_new_article"])

    front_user_1 = FactoryBot.create(:front_user, notifications_active: ["on_new_article"])
    front_user_2 = FactoryBot.create(:front_user, notifications_active: ["on_new_article"])
    front_user_3 = FactoryBot.create(:front_user, notifications_active: [])

    front_users = Notifications::OnNewArticleGetFrontUsersInterestedService.perform

    assert_primary_keys([front_user_1, front_user_2], front_users, true)
  end
end
