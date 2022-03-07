require "test_helper"

class Admin::ArticlesControllerTest < ActionController::TestCase
  def setup
    setup_admin_user
  end

  def test_index
    article_1 = FactoryBot.create(:article, created_at: "2020-04-25")
    article_2 = FactoryBot.create(:article, created_at: "2020-04-26")

    get :index

    assert_template "admin/articles/index"
    assert_primary_keys([article_2, article_1], assigns(:articles))
  end

  def test_show
    article = FactoryBot.create(:article)

    get :show, params: { id: article }

    assert_template "admin/articles/show"
    assert_equal(article, assigns(:article))
  end

  def test_new
    get :new
    assert_template "admin/articles/new"
    assert_not_nil(assigns(:article))
  end

  def test_create_invalid
    front_user_1 = FactoryBot.create(:front_user)

    Article.any_instance.stubs(:valid?).returns(false)

    post(
      :create,
      params: {
        article: {
          front_user: front_user_1,
          title: "The Title Wadus"
        }
      }
    )

    assert_template "new"
    assert_not_nil(flash[:alert])
  end

  def test_create_valid
    front_user_1 = FactoryBot.create(:front_user)

    post(
      :create,
      params: {
        article: {
          front_user_id: front_user_1,
          title: "The Title Wadus",
          body: "Wadus Message longer than 20 chars"
        }
      }
    )

    article = Article.last
    assert_redirected_to [:admin, article]

    assert_equal("The Title Wadus", article.title)
    assert_equal(front_user_1, article.front_user)
  end

  def test_edit
    article = FactoryBot.create(:article)

    get :edit, params: { id: article }

    assert_template "edit"
    assert_equal(article, assigns(:article))
  end

  def test_update_invalid
    article = FactoryBot.create(:article)

    Article.any_instance.stubs(:valid?).returns(false)

    put(
      :update,
      params: {
        id: article,
        article: {
          title: "The Wadus Message New"
        }
      }
    )

    assert_template "edit"
    assert_not_nil(flash[:alert])
  end

  def test_update_valid
    article = FactoryBot.create(:article)

    put(
      :update,
      params: {
        id: article,
        article: {
          title: "The Wadus Message New"
        }
      }
    )

    assert_redirected_to [:admin, article]
    assert_not_nil(flash[:notice])

    article.reload
    assert_equal("The Wadus Message New", article.title)
  end

  def test_destroy
    article = FactoryBot.create(:article)

    delete :destroy, params: { id: article }

    assert_redirected_to :admin_articles
    assert_not_nil(flash[:notice])

    assert !Article.exists?(article.id)
  end
end
