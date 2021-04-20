require "test_helper"

class Admin::AdminAuthorizationsControllerTest < ActionController::TestCase
  def test_create_when_user_already_authorized
    admin_user = FactoryBot.create(:admin_user)
    admin_authorization = FactoryBot.create(:admin_authorization, admin_user: admin_user)
    AdminAuthorization.expects(:find_from_omniauth_data).returns(admin_authorization)
    AdminSession.expects(:create).with(admin_user, true)

    @request.env["omniauth.auth"] = JSON.parse(read_fixture("google_auth_response.json"), symbolize_names: true)

    get :create, params: { provider: "google_oauth2" }

    assert_response 302
    assert_redirected_to :admin_root
  end

  def test_create_when_user_not_yet_authorized_and_email_present
    admin_user = FactoryBot.create(:admin_user, email: "john@email.com")
    AdminAuthorization.expects(:find_from_omniauth_data).returns(nil)
    AdminSession.expects(:create).with(admin_user, true)

    @request.env["omniauth.auth"] = JSON.parse(read_fixture("google_auth_response.json"), symbolize_names: true)

    get :create, params: { provider: "google_oauth2" }

    assert_response 302
    assert_redirected_to :admin_root
  end

  def test_create_when_user_not_yet_authorized_and_email_not_present
    admin_user = FactoryBot.create(:admin_user, email: "john@anotherprovider.com")
    AdminAuthorization.expects(:find_from_omniauth_data).returns(nil)
    AdminSession.expects(:create).with(admin_user, true).never

    @request.env["omniauth.auth"] = JSON.parse(read_fixture("google_auth_response.json"), symbolize_names: true)

    get :create, params: { provider: "google_oauth2" }

    assert_response 302
    assert_redirected_to :admin_login
  end
end
