require "test_helper"

class FrontUserTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:front_user).valid?
  end

  def test_uuid_on_create
    front_user = FactoryBot.build(:front_user)
    assert_nil(front_user.uuid)

    front_user.save!

    assert_not_nil(front_user.uuid)
  end

  def test_primary_key
    front_user = FactoryBot.create(:front_user)

    assert_equal(front_user, FrontUser.find(front_user.uuid))
  end

  def test_scope_order_by_recent
    front_user_1 = FactoryBot.create(:front_user, created_at: "2021-04-01")
    front_user_2 = FactoryBot.create(:front_user, created_at: "2021-04-02")
    front_user_3 = FactoryBot.create(:front_user, created_at: "2021-04-03")

    assert_primary_keys([front_user_3, front_user_2, front_user_1], FrontUser.order_by_recent)
  end

  ## Notifications :: INI
  def test_initialize_notifications_active_array
    front_user = FactoryBot.build(:front_user)
    assert_equal([], front_user.notifications_active)

    front_user.save!

    assert_equal([], front_user.notifications_active)
  end

  def test_notifications_active_are_allowed
    NotificationsRoles.expects(:for_role).with("front").at_least_once.returns(["on_event"])

    front_user = FactoryBot.create(:front_user)

    assert front_user.valid?

    front_user.notifications_active.push("on_event")
    assert front_user.valid?

    front_user.notifications_active.push("not_valid")
    refute front_user.valid?
    refute front_user.errors[:notifications_active].empty?
  end

  def test_notifications_active_are_allowed_only_if_notifications_active_changed
    NotificationsRoles.expects(:for_role).with("front").at_least_once.returns(["on_event"])

    front_user = FactoryBot.create(:front_user)
    front_user.update_attribute("notifications_active", ["not_valid"])
    assert front_user.valid?

    front_user.update!(name: "OTHER_NAME")
    assert front_user.valid?

    front_user.notifications_active.push("not_valid_2")
    refute front_user.valid?
    refute front_user.errors[:notifications_active].empty?
  end
  ## Notifications :: END

  def test_downcase_email
    front_user = FactoryBot.build(:front_user, email: "005@EXample.com")
    assert_equal("005@EXample.com", front_user.email)

    front_user.save!
    assert_equal("005@example.com", front_user.email)
  end
end
