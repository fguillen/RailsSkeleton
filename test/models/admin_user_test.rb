require "test_helper"

class AdminUserTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert FactoryBot.create(:admin_user).valid?
  end

  def test_send_reset_password_email
    admin_user = FactoryBot.create(:admin_user)
    old_perishable_token = admin_user.perishable_token

    mailer = mock
    mailer.expects(:deliver)
    Notifier.expects(:admin_user_reset_password).with(admin_user).returns(mailer)

    admin_user.send_reset_password_email

    assert_not_equal(old_perishable_token, admin_user.perishable_token)
  end

  def test_scope_order_by_recent
    admin_user_1 = FactoryBot.create(:admin_user, uuid: "1001", created_at: "2021-04-19")
    admin_user_2 = FactoryBot.create(:admin_user, uuid: "1002", created_at: "2021-04-20")
    admin_user_3 = FactoryBot.create(:admin_user, uuid: "1003", created_at: "2021-04-21")

    assert_primary_keys([admin_user_3, admin_user_2, admin_user_1], AdminUser.order_by_recent)
  end

  ## Notifications :: INI
  def test_initialize_notifications_active_array
    admin_user = FactoryBot.build(:admin_user)
    assert_equal([], admin_user.notifications_active)

    admin_user.save!

    assert_equal([], admin_user.notifications_active)
  end

  def test_notifications_active_are_allowed
    admin_user = FactoryBot.create(:admin_user)

    assert admin_user.valid?

    admin_user.notifications_active.push("on_new_front_user")
    assert admin_user.valid?

    admin_user.notifications_active.push("not_valid")
    refute admin_user.valid?
    refute admin_user.errors[:notifications_active].empty?
  end
  ## Notifications :: END
end
