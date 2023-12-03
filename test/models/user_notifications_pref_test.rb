require "test_helper"

class UserNotificationsPrefTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:user_notifications_pref).valid?
  end

  def test_uuid_on_create
    user_notifications_pref = FactoryBot.create(:user_notifications_pref)
    assert_not_nil(user_notifications_pref.uuid)
  end

  def test_relations_user
    front_user = FactoryBot.create(:front_user)
    front_user.user_notifications_pref.destroy
    user_notifications_pref = FactoryBot.create(:user_notifications_pref, user: front_user)

    assert_equal(front_user, user_notifications_pref.user)
  end

  def test_initialize_active_notifications_array
    user_notifications_pref = FactoryBot.build(:user_notifications_pref)
    assert_equal([], user_notifications_pref.active_notifications)

    user_notifications_pref.save!

    assert_equal([], user_notifications_pref.active_notifications)
  end

  def test_user_class_is_allowed_class
    user_notifications_pref = FactoryBot.create(:user_notifications_pref)
    front_user = FactoryBot.create(:front_user)
    admin_user = FactoryBot.create(:admin_user)
    admin_user = FactoryBot.create(:admin_user)

    assert user_notifications_pref.valid?

    user_notifications_pref.user = front_user
    assert user_notifications_pref.valid?

    user_notifications_pref.user = admin_user
    assert user_notifications_pref.valid?

    user_notifications_pref.user = user_notifications_pref
    refute user_notifications_pref.valid?
    refute user_notifications_pref.errors[:user].empty?
  end

  def test_active_notifications_are_allowed_class
    user_notifications_pref = FactoryBot.create(:user_notifications_pref)

    assert user_notifications_pref.valid?

    user_notifications_pref.active_notifications.push("on_new_front_user")
    assert user_notifications_pref.valid?

    user_notifications_pref.active_notifications.push("not_valid")
    refute user_notifications_pref.valid?
    refute user_notifications_pref.errors[:active_notifications].empty?
  end
end
