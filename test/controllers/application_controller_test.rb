require "test_helper"

class ApplicationControllerTest < ActionController::TestCase
  def test_health
    get :health

    assert_response :success
    assert_template :health
  end

  def test_unhealth
    ActiveRecord::Base.connection.expects(:active?).returns(false)

    exception = assert_raises RuntimeError do
      get :health
    end

    assert_match(/No DB connection/, exception.message)
  end
end
