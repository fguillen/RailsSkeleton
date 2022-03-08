require "test_helper"

class Guest::PagesControllerTest < ActionController::TestCase
  def test_show_welcome
    get(
      :show,
      params: {
        id: "welcome"
      }
    )

    assert_template "guest/pages/welcome"
  end
end
