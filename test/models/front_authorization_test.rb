require "test_helper"

class FrontAuthorizationTest < ActiveSupport::TestCase
  def test_find_from_omniauth_data
    front_authorization_1 = FactoryBot.create(:front_authorization, uid: "01")
    front_authorization_2 = FactoryBot.create(:front_authorization, uid: "02")

    assert_equal(front_authorization_1.id, FrontAuthorization.find_from_omniauth_data({ provider: "google_oauth2", uid: "01" }).id)
    assert_equal(front_authorization_2.id, FrontAuthorization.find_from_omniauth_data({ provider: "google_oauth2", uid: "02" }).id)
  end

  def test_create_user_from_omniauth_data
    omniauth_data = {
      info: {
        name: "NAME",
        email: "EMAIL@EXAMPLE.COM"
      }
    }

    front_user = nil

    assert_difference("FrontUser.count", 1) do
      front_user = FrontAuthorization.create_user_from_omniauth_data(omniauth_data)
    end

    assert_equal("NAME", front_user.name)
    assert_equal("email@example.com", front_user.email)
  end

  def test_on_create_initialize_uid_and_provider
    omniauth_data = {
      uid: "UID",
      provider: "PROVIDER"
    }

    front_user = FactoryBot.create(:front_user)

    front_authorization = FrontAuthorization.create!(front_user: front_user, omniauth_data: omniauth_data)

    assert_equal(front_user, front_authorization.front_user)
    assert_equal("UID", front_authorization.uid)
    assert_equal("PROVIDER", front_authorization.provider)
  end
end
