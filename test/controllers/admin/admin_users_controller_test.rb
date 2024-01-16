require "test_helper"

class Admin::AdminUsersControllerTest < ActionController::TestCase
  def setup
    setup_admin_user
  end

  def test_index
    admin_user_1 = FactoryBot.create(:admin_user, uuid: "UUID_1", created_at: "2020-04-25")
    admin_user_2 = FactoryBot.create(:admin_user, uuid: "UUID_2", created_at: "2020-04-26")

    get :index

    assert_template "admin/admin_users/index"
    assert_primary_keys([admin_user_2, admin_user_1, @admin_user], assigns(:admin_users))
  end

  def test_show
    admin_user = FactoryBot.create(:admin_user)

    get :show, params: { id: admin_user }

    assert_template "admin/admin_users/show"
    assert_equal(admin_user, assigns(:admin_user))
  end

  def test_new
    get :new
    assert_template "admin/admin_users/new"
    assert_not_nil(assigns(:admin_user))
  end

  def test_create_invalid
    AdminUser.any_instance.stubs(:valid?).returns(false)
    post(
      :create,
      params: {
        admin_user: {
          name: "Admin Wadus",
          email: "email@email.com",
          password: "Password!",
          password_confirmation: "Password!"
        }
      }
    )
    assert_template "new"
    assert_not_nil(flash[:alert])
  end

  def test_create_valid
    post(
      :create,
      params: {
        admin_user: {
          name: "Admin Wadus",
          email: "email@email.com",
          password: "Password!",
          password_confirmation: "Password!"
        }
      }
    )

    admin_user = AdminUser.order_by_recent.first
    assert_redirected_to [:admin, admin_user]

    assert_equal("Admin Wadus", admin_user.name)
    assert_equal("email@email.com", admin_user.email)
  end

  def test_edit
    admin_user = FactoryBot.create(:admin_user)

    get :edit, params: { id: admin_user }

    assert_template "edit"
    assert_equal(admin_user, assigns(:admin_user))
  end

  def test_update_invalid
    admin_user = FactoryBot.create(:admin_user)
    AdminUser.any_instance.stubs(:valid?).returns(false)

    put :update, params: { id: admin_user, admin_user: { password: "password", password_confirmation: "invalid" } }

    assert_template "edit"
    assert_not_nil(flash[:alert])
  end

  def test_update_valid
    admin_user = FactoryBot.create(:admin_user)

    put(
      :update,
      params: {
        id: admin_user,
        admin_user: {
          name: "Other Name"
        }
      }
    )

    assert_redirected_to [:admin, admin_user]
    assert_not_nil(flash[:notice])

    admin_user.reload
    assert_equal("Other Name", admin_user.name)
  end

  def test_destroy
    admin_user = FactoryBot.create(:admin_user)

    delete :destroy, params: { id: admin_user }

    assert_redirected_to :admin_admin_users
    assert_not_nil(flash[:notice])

    assert !AdminUser.exists?(admin_user.id)
  end

  def test_reset_password
    admin_user = FactoryBot.create(:admin_user)
    get(
      :reset_password,
      params: { reset_password_code: admin_user.perishable_token }
    )

    assert_template "reset_password"
  end

  def test_reset_password_submit
    admin_user = FactoryBot.create(:admin_user, email: "email@email.com")

    put(
      :reset_password_submit,
      params: {
        reset_password_code: admin_user.perishable_token,
        admin_user: {
          password: "Password!",
          password_confirmation: "Password!"
        }
      }
    )

    assert_redirected_to admin_root_path
    assert_not_nil(flash[:notice])

    # assert_equal admin_user, AdminSession.new(:email => "email@email.com", :password => "PASS").record
  end

  ## Notifications :: INI
  def test_update_notifications_active
    NotificationsRoles.expects(:for_role).with("admin").at_least_once.returns(["on_event"])

    admin_user = FactoryBot.create(:admin_user, notifications_active: [])

    put(
      :update,
      params: {
        id: admin_user,
        admin_user: {
          notifications_active: ["on_event"]
        }
      }
    )

    assert_redirected_to [:admin, admin_user]
    assert_not_nil(flash[:notice])

    admin_user.reload
    assert_equal(["on_event"], admin_user.notifications_active)
  end

  def test_update_notifications_active_when_empty
    NotificationsRoles.expects(:for_role).with("admin").at_least_once.returns(["on_event"])

    admin_user = FactoryBot.create(:admin_user, notifications_active: ["on_event"])
    assert_equal(["on_event"], admin_user.notifications_active)

    put(
      :update,
      params: {
        id: admin_user,
        admin_user: {
          notifications_active: ["", nil]
        }
      }
    )

    assert_redirected_to [:admin, admin_user]
    assert_not_nil(flash[:notice])

    admin_user.reload
    assert_equal([], admin_user.notifications_active)
  end
  ## Notifications :: END
end
