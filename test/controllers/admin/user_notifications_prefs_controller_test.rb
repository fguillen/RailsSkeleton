require "test_helper"

class Admin::UserNotificationsPrefsControllerTest < ActionController::TestCase
  def setup
    setup_admin_user
  end

  def test_edit
    admin_user = FactoryBot.create(:admin_user)

    get :edit, params: { admin_user_id: admin_user }

    assert_template "edit"
  end

  def test_update_invalid
    admin_user = FactoryBot.create(:admin_user)
    user_notifications_pref = admin_user.user_notifications_pref

    UserNotificationsPref.any_instance.stubs(:valid?).returns(false)

    put(
      :update,
      params: {
        admin_user_id: admin_user,
        user_notifications_pref: {
          active_notifications: ["no_valid"]
        }
      }
    )

    assert_template "edit"
    assert_not_nil(flash[:alert])
  end

  def test_update_valid
    admin_user = FactoryBot.create(:admin_user)
    user_notifications_pref = admin_user.user_notifications_pref

    put(
      :update,
      params: {
        admin_user_id: admin_user,
        user_notifications_pref: {
          active_notifications: ["on_new_article", "on_new_front_user"]
        }
      }
    )

    assert_redirected_to edit_admin_admin_user_user_notifications_pref_path(user_admin_id: admin_user)
    assert_not_nil(flash[:notice])

    user_notifications_pref.reload
    assert_equal(["on_new_article", "on_new_front_user"], user_notifications_pref.active_notifications)
  end

  def test_update_empty
    admin_user = FactoryBot.create(:admin_user)
    user_notifications_pref = admin_user.user_notifications_pref
    user_notifications_pref.update(active_notifications: ["on_new_article", "on_new_front_user"])
    assert_equal(["on_new_article", "on_new_front_user"], user_notifications_pref.active_notifications)

    put(
      :update,
      params: {
        admin_user_id: admin_user,
        user_notifications_pref: {
          active_notifications: ["", nil]
        }
      }
    )

    assert_redirected_to edit_admin_admin_user_user_notifications_pref_path(user_admin_id: admin_user)
    assert_not_nil(flash[:notice])

    user_notifications_pref.reload
    assert_equal([], user_notifications_pref.active_notifications)
  end
end
