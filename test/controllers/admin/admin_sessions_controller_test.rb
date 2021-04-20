require "test_helper"

class Admin::AdminSessionsControllerTest < ActionController::TestCase
  def test_should_get_new
    get :new
    assert_response :success
    assert_template "admin/admin_sessions/new"
  end

  def test_create
    admin_user = FactoryBot.create(:admin_user)
    post(
      :create,
      params: {
        admin_session: {
          email: admin_user.email,
          password: admin_user.password
        }
      }
    )

    assert_redirected_to :admin_root
    assert_not_nil(flash[:notice])
  end

  def test_create_invalid
    post(
      :create,
      params: {
        admin_session: {
          email: "email",
          password: "password"
        }
      }
    )

    assert_template "admin/admin_sessions/new"
    assert_not_nil(flash[:alert])
  end

  def test_destroy
    delete :destroy
    assert_redirected_to admin_login_path
    assert_not_nil(flash[:notice])
  end

  def test_forgot_password
    get(:forgot_password)
    assert_template "admin/admin_sessions/forgot_password"
  end

  def test_forgot_password_submit_with_no_valid_email
    post(
      :forgot_password_submit,
      params: {
        admin_session: {
          email: "not-exists"
        }
      }
    )

    assert_redirected_to admin_forgot_password_path
    assert_not_nil(flash[:alert])
  end

  def test_forgot_password_submit
    admin_user = FactoryBot.create(:admin_user)
    AdminUser.any_instance.expects(:send_reset_password_email)

    post(
      :forgot_password_submit,
      params: {
        admin_session: {
          email: admin_user.email
        }
      }
    )

    assert_redirected_to admin_forgot_password_path
    assert_not_nil(flash[:notice])
  end
end
