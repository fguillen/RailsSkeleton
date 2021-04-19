require "test_helper"

class Admin::AppreciableUsersControllerTest < ActionController::TestCase
  def setup
    setup_admin_user
  end

  def test_index
    appreciable_user_1 = FactoryBot.create(:appreciable_user, created_at: "2020-04-25")
    appreciable_user_2 = FactoryBot.create(:appreciable_user, created_at: "2020-04-26")

    get :index

    assert_template "admin/appreciable_users/index"
    assert_primary_keys([appreciable_user_2, appreciable_user_1], assigns(:appreciable_users))
  end

  def test_show
    appreciable_user = FactoryBot.create(:appreciable_user)
    appreciation = FactoryBot.create(:appreciation, by: appreciable_user, to: [appreciable_user])

    get :show, :params => {:id => appreciable_user}

    assert_template "admin/appreciable_users/show"
    assert_equal(appreciable_user, assigns(:appreciable_user))
  end

  def test_new
    get :new
    assert_template "admin/appreciable_users/new"
    assert_not_nil(assigns(:appreciable_user))
  end

  def test_create_invalid
    AppreciableUser.any_instance.stubs(:valid?).returns(false)
    post(
      :create,
      :params => {
        :appreciable_user => {
          :name => "Admin Wadus",
          :email => "email@email.com",
          :password => "Password!",
          :password_confirmation => "Password!"
        }
      }
    )
    assert_template "new"
    assert_not_nil(flash[:alert])
  end

  def test_create_valid
    post(
      :create,
      :params => {
        :appreciable_user => {
          :name => "Admin Wadus",
          :email => "email@email.com",
          :password => "Password!",
          :password_confirmation => "Password!"
        }
      }
    )

    appreciable_user = AppreciableUser.last
    assert_redirected_to [:admin, appreciable_user]

    assert_equal("Admin Wadus", appreciable_user.name)
    assert_equal("email@email.com", appreciable_user.email)
  end

  def test_edit
    appreciable_user = FactoryBot.create(:appreciable_user)

    get :edit, :params => {:id => appreciable_user}

    assert_template "edit"
    assert_equal(appreciable_user, assigns(:appreciable_user))
  end

  def test_update_invalid
    appreciable_user = FactoryBot.create(:appreciable_user)
    AppreciableUser.any_instance.stubs(:valid?).returns(false)

    put :update, :params => { :id => appreciable_user, :appreciable_user => { :password => "password", :password_confirmation => "invalid" } }

    assert_template "edit"
    assert_not_nil(flash[:alert])
  end

  def test_update_valid
    appreciable_user = FactoryBot.create(:appreciable_user)

    put(
      :update,
      :params => {
        :id => appreciable_user,
        :appreciable_user => {
          :name => "Other Name"
        }
      }
    )

    assert_redirected_to [:admin, appreciable_user]
    assert_not_nil(flash[:notice])

    appreciable_user.reload
    assert_equal("Other Name", appreciable_user.name)
  end

  def test_destroy
    appreciable_user = FactoryBot.create(:appreciable_user)

    delete :destroy, :params => {:id => appreciable_user}

    assert_redirected_to :admin_appreciable_users
    assert_not_nil(flash[:notice])

    assert !AppreciableUser.exists?(appreciable_user.id)
  end
end
