require "test_helper"

class Guest::ArticlesControllerTest < ActionController::TestCase
  def test_index
    article_1 = FactoryBot.create(:article, created_at: "2020-04-25")
    article_2 = FactoryBot.create(:article, created_at: "2020-04-26")

    get :index

    assert_template "guest/articles/index"
    assert_primary_keys([article_2, article_1], assigns(:articles))
  end

  def test_show
    article = FactoryBot.create(:article)

    get :show, params: { id: article }

    assert_template "guest/articles/show"
    assert_equal(article, assigns(:article))
  end
end
