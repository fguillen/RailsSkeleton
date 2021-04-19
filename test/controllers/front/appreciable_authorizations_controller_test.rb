require "test_helper"

class Front::AppreciableAuthorizationsControllerTest < ActionController::TestCase

  def test_create_when_user_already_authorized
    appreciable_user = FactoryBot.create(:appreciable_user)
    appreciable_authorization = FactoryBot.create(:appreciable_authorization, :appreciable_user => appreciable_user)
    AppreciableAuthorization.expects(:find_from_omniauth_data).returns(appreciable_authorization)
    AppreciableSession.expects(:create).with(appreciable_user,true)

    @request.env["omniauth.auth"] = JSON.parse(read_fixture("google_auth_response.json"),:symbolize_names => true)

    get :create, :params => { :provider => "google_oauth2" }

    assert_response 302
    assert_redirected_to :front_root
  end

  def test_create_when_user_not_yet_authorized_and_email_present
    appreciable_user = FactoryBot.create(:appreciable_user, :email => "john@email.com")
    AppreciableAuthorization.expects(:find_from_omniauth_data).returns(nil)
    AppreciableSession.expects(:create).with(appreciable_user,true)

    @request.env["omniauth.auth"] = JSON.parse(read_fixture("google_auth_response.json"),:symbolize_names => true)

    get :create, :params => { :provider => "google_oauth2" }

    assert_response 302
    assert_redirected_to :front_root
  end

  def test_create_when_user_not_yet_authorized_and_email_not_present
    appreciable_user = FactoryBot.create(:appreciable_user, :email => "john@anotherprovider.com")
    AppreciableAuthorization.expects(:find_from_omniauth_data).returns(nil)
    AppreciableSession.expects(:create).with(appreciable_user,true).never

    @request.env["omniauth.auth"] = JSON.parse(read_fixture("google_auth_response.json"),:symbolize_names => true)

    get :create, :params => { :provider => "google_oauth2" }

    assert_response 302
    assert_redirected_to :front_login
  end
end
