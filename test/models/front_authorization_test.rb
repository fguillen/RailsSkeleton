require "test_helper"

class FrontAuthorizationTest < ActiveSupport::TestCase
  def test_find_from_omniauth_data
    front_authorization_1 = FactoryBot.create(:front_authorization, uid: "01")
    front_authorization_2 = FactoryBot.create(:front_authorization, uid: "02")

    assert_equal(front_authorization_1.id, FrontAuthorization.find_from_omniauth_data({ "provider" => "google_oauth2", "uid" => "01" }).id)
    assert_equal(front_authorization_2.id, FrontAuthorization.find_from_omniauth_data({ "provider" => "google_oauth2", "uid" => "02" }).id)
  end
end
