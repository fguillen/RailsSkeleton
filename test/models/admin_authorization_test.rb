require "test_helper"

class AdminAuthorizationTest < ActiveSupport::TestCase
  def test_find_from_omniauth_data
    admin_authorization_1 = FactoryBot.create(:admin_authorization, uid: "01")
    admin_authorization_2 = FactoryBot.create(:admin_authorization, uid: "02")

    assert_equal(admin_authorization_1.id, AdminAuthorization.find_from_omniauth_data({ "provider" => "google_oauth2", "uid" => "01" }).id)
    assert_equal(admin_authorization_2.id, AdminAuthorization.find_from_omniauth_data({ "provider" => "google_oauth2", "uid" => "02" }).id)
  end
end
