require "test_helper"

class Front::FrontSessionsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_response :success
    assert_template "front/front_sessions/new"
  end

  def test_destroy
    delete :destroy
    assert_redirected_to :root
    assert_not_nil( flash[:notice] )
  end
end
