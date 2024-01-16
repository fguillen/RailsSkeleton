require "test_helper"

class Admin::FrontUsersControllerTest < ActionController::TestCase
  def setup
    setup_admin_user
  end

  def test_index
    front_user_1 = FactoryBot.create(:front_user, created_at: "2020-04-25")
    front_user_2 = FactoryBot.create(:front_user, created_at: "2020-04-26")

    get :index

    assert_template "admin/front_users/index"
    assert_primary_keys([front_user_2, front_user_1], assigns(:front_users))
  end

  def test_show
    front_user = FactoryBot.create(:front_user)
    FactoryBot.create(:article, front_user: front_user)

    get :show, params: { id: front_user }

    assert_template "admin/front_users/show"
    assert_equal(front_user, assigns(:front_user))
  end

  def test_new
    get :new
    assert_template "admin/front_users/new"
    assert_not_nil(assigns(:front_user))
  end

  def test_create_invalid
    FrontUser.any_instance.stubs(:valid?).returns(false)
    post(
      :create,
      params: {
        front_user: {
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
        front_user: {
          name: "Admin Wadus",
          email: "email@email.com",
          password: "Password!",
          password_confirmation: "Password!"
        }
      }
    )

    front_user = FrontUser.last
    assert_redirected_to [:admin, front_user]

    assert_equal("Admin Wadus", front_user.name)
    assert_equal("email@email.com", front_user.email)
  end

  def test_edit
    front_user = FactoryBot.create(:front_user)

    get :edit, params: { id: front_user }

    assert_template "edit"
    assert_equal(front_user, assigns(:front_user))
  end

  def test_update_invalid
    front_user = FactoryBot.create(:front_user)
    FrontUser.any_instance.stubs(:valid?).returns(false)

    put :update, params: { id: front_user, front_user: { password: "password", password_confirmation: "invalid" } }

    assert_template "edit"
    assert_not_nil(flash[:alert])
  end

  def test_update_valid
    front_user = FactoryBot.create(:front_user)

    put(
      :update,
      params: {
        id: front_user,
        front_user: {
          name: "Other Name"
        }
      }
    )

    assert_redirected_to [:admin, front_user]
    assert_not_nil(flash[:notice])

    front_user.reload
    assert_equal("Other Name", front_user.name)
  end

  def test_destroy
    front_user = FactoryBot.create(:front_user)

    delete :destroy, params: { id: front_user }

    assert_redirected_to :admin_front_users
    assert_not_nil(flash[:notice])

    assert !FrontUser.exists?(front_user.id)
  end

  def test_articles
    front_user = FactoryBot.create(:front_user)
    article = FactoryBot.create(:article, front_user: front_user)

    get(
      :articles,
      params: {
        id: front_user
      }
    )

    assert_primary_keys([article], assigns(:articles))
  end

  def test_log_book_events
    front_user = FactoryBot.create(:front_user)
    log_book_event = FactoryBot.create(:log_book_event, historizable: front_user)

    get(
      :log_book_events,
      params: {
        id: front_user
      }
    )

    assert_equal(log_book_event.id, assigns(:log_book_events).first.id)
    assert_template "log_book_events"
  end

  ## Notifications :: INI
  def test_update_notifications_active
    NotificationsRoles.expects(:for_role).with("front").at_least_once.returns(["on_event"])

    front_user = FactoryBot.create(:front_user, notifications_active: [])

    put(
      :update,
      params: {
        id: front_user,
        front_user: {
          notifications_active: ["on_event"]
        }
      }
    )

    assert_redirected_to [:admin, front_user]
    assert_not_nil(flash[:notice])

    front_user.reload
    assert_equal(["on_event"], front_user.notifications_active)
  end

  def test_update_notifications_active_when_empty
    NotificationsRoles.expects(:for_role).with("front").at_least_once.returns(["on_event"])

    front_user = FactoryBot.create(:front_user, notifications_active: ["on_event"])
    assert_equal(["on_event"], front_user.notifications_active)

    put(
      :update,
      params: {
        id: front_user,
        front_user: {
          notifications_active: ["", nil]
        }
      }
    )

    assert_redirected_to [:admin, front_user]
    assert_not_nil(flash[:notice])

    front_user.reload
    assert_equal([], front_user.notifications_active)
  end
  ## Notifications :: END
end
