require "test_helper"

class Front::FrontSessionsControllerTest < ActionController::TestCase
  def test_should_get_new
    get :new
    assert_response :success
    assert_template "front/front_sessions/new"
  end

  def test_create
    front_user = FactoryBot.create(:front_user)
    post(
      :create,
      params: {
        front_session: {
          email: front_user.email,
          password: front_user.password
        }
      }
    )

    assert_redirected_to :front_root
    assert_not_nil(flash[:notice])
  end

  def test_create_invalid
    post(
      :create,
      params: {
        front_session: {
          email: "email",
          password: "password"
        }
      }
    )

    assert_template "front/front_sessions/new"
    assert_not_nil(flash[:alert])
  end

  def test_destroy
    delete :destroy
    assert_redirected_to front_login_path
    assert_not_nil(flash[:notice])
  end

  def test_forgot_password
    get(:forgot_password)
    assert_template "front/front_sessions/forgot_password"
  end

  def test_forgot_password_submit_with_no_valid_email
    post(
      :forgot_password_submit,
      params: {
        front_session: {
          email: "not-exists"
        }
      }
    )

    assert_redirected_to front_forgot_password_path
    assert_not_nil(flash[:alert])
  end

  def test_forgot_password_submit
    front_user = FactoryBot.create(:front_user)
    FrontUser.any_instance.expects(:send_reset_password_email)

    post(
      :forgot_password_submit,
      params: {
        front_session: {
          email: front_user.email
        }
      }
    )

    assert_redirected_to front_forgot_password_path
    assert_not_nil(flash[:notice])
  end
end
