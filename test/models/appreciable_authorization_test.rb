require "test_helper"

class AppreciableAuthorizationTest < ActiveSupport::TestCase
  def test_find_from_omniauth_data
    appreciable_authorization_1 = FactoryBot.create(:appreciable_authorization, :uid => "01")
    appreciable_authorization_2 = FactoryBot.create(:appreciable_authorization, :uid => "02")

    assert_equal(appreciable_authorization_1.id, AppreciableAuthorization.find_from_omniauth_data({"provider" => "google_oauth2","uid" => "01"}).id )
    assert_equal(appreciable_authorization_2.id, AppreciableAuthorization.find_from_omniauth_data({"provider" => "google_oauth2","uid" => "02"}).id )
  end
end
