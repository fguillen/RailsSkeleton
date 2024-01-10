require "test_helper"

class Notifications::GetFrontUsersInterestedOnNewArticleServiceTest < ActiveSupport::TestCase
  def test_perform
    front_user_1 = FactoryBot.create(:front_user, notifications_active: ["on_new_article"])
    front_user_2 = FactoryBot.create(:front_user, notifications_active: ["on_new_article"])
    front_user_3 = FactoryBot.create(:front_user, notifications_active: [])

    front_users = Notifications::GetFrontUsersInterestedOnNewArticleService.perform

    assert_primary_keys([front_user_1, front_user_2], front_users, true)
  end
end
