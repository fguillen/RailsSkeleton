require "test_helper"

class AdminAuthorizationTest < ActiveSupport::TestCase
  def test_find_from_omniauth_data
    admin_authorization_1 = FactoryBot.create(:admin_authorization, uid: "01")
    admin_authorization_2 = FactoryBot.create(:admin_authorization, uid: "02")

    assert_equal(admin_authorization_1.id, AdminAuthorization.find_from_omniauth_data({ provider: "google_oauth2", uid: "01" }).id)
    assert_equal(admin_authorization_2.id, AdminAuthorization.find_from_omniauth_data({ provider: "google_oauth2", uid: "02" }).id)
  end

  def test_on_create_initialize_uid_and_provider
    omniauth_data = {
      uid: "UID",
      provider: "PROVIDER"
    }

    admin_user = FactoryBot.create(:admin_user)

    admin_authorization = AdminAuthorization.create!(admin_user: admin_user, omniauth_data: omniauth_data)

    assert_equal(admin_user, admin_authorization.admin_user)
    assert_equal("UID", admin_authorization.uid)
    assert_equal("PROVIDER", admin_authorization.provider)
  end
end
