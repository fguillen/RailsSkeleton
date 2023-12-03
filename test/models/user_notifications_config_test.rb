require "test_helper"

class UserNotificationsConfiUsergTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:user_notifications_config).valid?
  end

  def test_uuid_on_create
    user_notifications_config = FactoryBot.build(:user_notifications_config)
    assert_nil(user_notifications_config.uuid)

    user_notifications_config.save!

    assert_not_nil(user_notifications_config.uuid)
  end

  def test_primary_key
    user_notifications_config = FactoryBot.create(:user_notifications_config)

    assert_equal(user_notifications_config, UserNotificationsConfig.find(user_notifications_config.uuid))
  end

  def test_relations_user
    front_user = FactoryBot.create(:front_user)
    user_notifications_config = FactoryBot.create(:user_notifications_config, user: front_user)

    assert_equal(front_user, user_notifications_config.user)
  end

  def test_initialize_active_notifications_array
    user_notifications_config = FactoryBot.build(:user_notifications_config)
    assert_equal([], user_notifications_config.active_notifications)

    user_notifications_config.save!

    assert_equal([], user_notifications_config.active_notifications)
  end

end
