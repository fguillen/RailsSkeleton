require "test_helper"

class Front::FrontAuthorizationsControllerTest < ActionController::TestCase
  def test_create_when_user_already_authorized
    front_user = FactoryBot.create(:front_user)
    front_authorization = FactoryBot.create(:front_authorization, front_user: front_user)
    FrontAuthorization.expects(:find_from_omniauth_data).returns(front_authorization)
    FrontSession.expects(:create).with(front_user, true)

    @request.env["omniauth.auth"] = JSON.parse(read_fixture("google_auth_response.json"), symbolize_names: true)

    get :create, params: { provider: "google_oauth2" }

    assert_response 302
    assert_redirected_to :front_root
  end

  def test_create_when_user_not_yet_authorized_and_email_present
    front_user = FactoryBot.create(:front_user, email: "john@email.com")
    FrontAuthorization.expects(:find_from_omniauth_data).returns(nil)
    FrontSession.expects(:create).with(front_user, true)

    @request.env["omniauth.auth"] = JSON.parse(read_fixture("google_auth_response.json"), symbolize_names: true)

    get :create, params: { provider: "google_oauth2" }

    assert_response 302
    assert_redirected_to :front_root
  end

  def test_create_when_user_not_yet_authorized_and_email_not_present
    front_user = FactoryBot.create(:front_user, email: "john@anotherprovider.com")
    FrontAuthorization.expects(:find_from_omniauth_data).returns(nil)
    FrontSession.expects(:create).with(front_user, true).never

    @request.env["omniauth.auth"] = JSON.parse(read_fixture("google_auth_response.json"), symbolize_names: true)

    get :create, params: { provider: "google_oauth2" }

    assert_response 302
    assert_redirected_to :front_login
  end
end
