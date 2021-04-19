require "test_helper"

class Api::Admin::AdminUsersControllerTest < ActionController::TestCase
  def assert_unauthorized
    assert_response :unauthorized
  end

  def test_unauthorized
    FactoryBot.create(:admin_user)

    get :index
    assert_unauthorized

    request.env["HTTP_AUTHORIZATION"] = "Token TEST_ADMIN_TOKEN_2"

    get :index
    assert_unauthorized

    request.env["HTTP_AUTHORIZATION"] = "TEST_ADMIN_TOKEN_2"

    get :index
    assert_unauthorized

    request.env["HTTP_AUTHORIZATION"] = "ScrapStats invalid-token-#{SecureRandom.uuid}"

    get :index
    assert_unauthorized
  end

  def test_index
    request.env["HTTP_AUTHORIZATION"] = "ScrapStats TEST_ADMIN_TOKEN_2"

    FactoryBot.create(:admin_user, created_at: "2021-04-01", name: "ADMIN_USER_1")
    FactoryBot.create(:admin_user, created_at: "2021-04-02", name: "ADMIN_USER_2")
    FactoryBot.create(:admin_user, created_at: "2021-04-03", name: "ADMIN_USER_3")

    get :index

    assert_response :success

    expected_result = [
      { "name" => "ADMIN_USER_3" },
      { "name" => "ADMIN_USER_2" },
      { "name" => "ADMIN_USER_1" }
    ]
    assert_equal expected_result, JSON.parse(response.body)
  end
end
