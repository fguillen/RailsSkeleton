require "test_helper"

class SpecialRoutesTest < ActionDispatch::IntegrationTest
  def test_admin_login
    get "/admin/login"
    assert_response :success
  end

  def test_front_my_profile
    front_user = FactoryBot.create(:front_user)
    Front::FrontUsersController.any_instance.stubs(:current_front_user).returns(front_user)

    get "/front/my_profile"
    assert_redirected_to [:front, front_user]
  end
end
