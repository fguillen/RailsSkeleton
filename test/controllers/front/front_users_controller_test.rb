require "test_helper"

class Front::FrontUsersControllerTest < ActionController::TestCase
  def setup
    setup_front_user
  end

  def test_show
    FactoryBot.create(:article, front_user: @front_user)

    get :show, params: { id: @front_user }

    assert_template "front/front_users/show"
    assert_equal(@front_user, assigns(:front_user))
  end

  def test_new
    get :new
    assert_template "front/front_users/new"
    assert_not_nil(assigns(:front_user))
  end

  def test_create_invalid
    @controller.expects(:valid_captcha?).returns(true)
    FrontUser.any_instance.stubs(:valid?).returns(false)

    post(
      :create,
      params: {
        front_user: {
          name: "Front Wadus",
          email: "email@email.com",
          password: "Password!",
          password_confirmation: "Password!"
        }
      }
    )
    assert_template "new"
    assert_not_nil(flash[:alert])
  end

  def test_create_invalid_captcha
    @controller.expects(:valid_captcha?).returns(false)

    post(
      :create,
      params: {
        front_user: {
          name: "Front Wadus",
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
    @controller.expects(:valid_captcha?).returns(true)

    post(
      :create,
      params: {
        front_user: {
          name: "Front Wadus",
          email: "email@email.com",
          password: "Password!",
          password_confirmation: "Password!"
        }
      }
    )

    front_user = FrontUser.find_by(email: "email@email.com")
    assert_redirected_to [:front, front_user]

    assert_equal("Front Wadus", front_user.name)
    assert_equal("email@email.com", front_user.email)
  end

  def test_edit
    get :edit, params: { id: @front_user }

    assert_template "edit"
    assert_equal(@front_user, assigns(:front_user))
  end

  def test_update_invalid
    FrontUser.any_instance.stubs(:valid?).returns(false)

    put :update, params: { id: @front_user, front_user: { password: "password", password_confirmation: "invalid" } }

    assert_template "edit"
    assert_not_nil(flash[:alert])
  end

  def test_update_valid
    put(
      :update,
      params: {
        id: @front_user,
        front_user: {
          name: "Other Name"
        }
      }
    )

    assert_redirected_to [:front, @front_user]
    assert_not_nil(flash[:notice])

    @front_user.reload
    assert_equal("Other Name", @front_user.name)
  end

  def test_destroy
    delete :destroy, params: { id: @front_user }

    assert_redirected_to :front_root
    assert_not_nil(flash[:notice])

    assert !FrontUser.exists?(@front_user.id)
  end

  def test_reset_password
    front_user = FactoryBot.create(:front_user)
    get(
      :reset_password,
      params: { reset_password_code: front_user.perishable_token }
    )

    assert_template "reset_password"
  end

  def test_reset_password_submit
    front_user = FactoryBot.create(:front_user, email: "email@email.com")

    put(
      :reset_password_submit,
      params: {
        reset_password_code: front_user.perishable_token,
        front_user: {
          password: "Password!",
          password_confirmation: "Password!"
        }
      }
    )

    assert_redirected_to front_root_path
    assert_not_nil(flash[:notice])

    # assert_equal front_user, AdminSession.new(:email => "email@email.com", :password => "PASS").record
  end

  ## Notifications :: INI
  def test_update_notifications_active
    NotificationsRoles.expects(:for_role).with("front").at_least_once.returns(["on_event"])

    put(
      :update,
      params: {
        id: @front_user,
        front_user: {
          notifications_active: ["on_event"]
        }
      }
    )

    assert_redirected_to [:front, @front_user]
    assert_not_nil(flash[:notice])

    @front_user.reload
    assert_equal(["on_event"], @front_user.notifications_active)
  end

  def test_update_notifications_active_when_empty
    NotificationsRoles.expects(:for_role).with("front").at_least_once.returns(["on_event"])

    @front_user.update(notifications_active: ["on_event"])
    assert_equal(["on_event"], @front_user.notifications_active)

    put(
      :update,
      params: {
        id: @front_user,
        front_user: {
          notifications_active: ["", nil]
        }
      }
    )

    assert_redirected_to [:front, @front_user]
    assert_not_nil(flash[:notice])

    @front_user.reload
    assert_equal([], @front_user.notifications_active)
  end
  ## Notifications :: END

  def test_my_profile
    get :my_profile
    assert_redirected_to [:front, @front_user]
  end
end
