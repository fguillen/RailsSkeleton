require "test_helper"

class Admin::ArticlesFiltersControllerTest < ActionController::TestCase
  def setup
    setup_admin_user
  end

  def test_new
    get :new
    assert_template "new"
    assert_not_nil(assigns(:articles_filter))
  end

  def test_create_invalid
    ArticlesFilter.any_instance.stubs(:valid?).returns(false)

    get(
      :create,
      params: {
        articles_filter: {
          title: "The Title Wadus"
        }
      }
    )

    assert_template "new"
    assert_not_nil(flash[:alert])
  end

  def test_create_valid
    get(
      :create,
      params: {
        articles_filter: {
          title: "TITLE"
        }
      }
    )

    articles_filter = assigns(:articles_filter)
    assert_template "show"

    assert_equal("TITLE", articles_filter.title)
  end
end
