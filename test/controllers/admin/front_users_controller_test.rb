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
    post = FactoryBot.create(:post, front_user: front_user)

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
    AppreciableUser.any_instance.stubs(:valid?).returns(false)
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

    front_user = AppreciableUser.last
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
    AppreciableUser.any_instance.stubs(:valid?).returns(false)

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

    assert !AppreciableUser.exists?(front_user.id)
  end
end
