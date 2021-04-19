require "test_helper"

class Front::PagesControllerTest < ActionController::TestCase
  def test_show_welcome
    get(
      :show,
      params: {
        id: "welcome"
      }
    )

    assert_template "front/pages/welcome"
  end
end
