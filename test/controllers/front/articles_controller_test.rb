require "test_helper"

class Front::ArticlesControllerTest < ActionController::TestCase
  def setup
    setup_front_user
  end

  def test_index
    article_1 = FactoryBot.create(:article, created_at: "2020-04-25", front_user: @front_user)
    article_2 = FactoryBot.create(:article, created_at: "2020-04-26", front_user: @front_user)
    article_3 = FactoryBot.create(:article, created_at: "2020-04-27")

    get :index

    assert_template "front/articles/index"
    assert_primary_keys([article_2, article_1], assigns(:articles))
  end

  def test_show
    article = FactoryBot.create(:article, front_user: @front_user)

    get :show, params: { id: article }

    assert_template "front/articles/show"
    assert_equal(article, assigns(:article))
  end

  def test_new
    get :new
    assert_template "front/articles/new"
    assert_not_nil(assigns(:article))
  end

  def test_create_invalid
    front_user_1 = FactoryBot.create(:front_user)

    Article.any_instance.stubs(:valid?).returns(false)

    post(
      :create,
      params: {
        article: {
          front_user_id: front_user_1,
          title: "The Title Wadus"
        }
      }
    )

    assert_template "new"
    assert_not_nil(flash[:alert])
  end

  def test_create_valid
    post(
      :create,
      params: {
        article: {
          title: "The Title Wadus",
          body: "The Body Wadus Wadus Wadus Wadus",
          tag_list: "one, two",
          pic: fixture_file_upload("yourule.png")
        }
      }
    )

    article = Article.last
    assert_redirected_to [:front, article]

    assert_equal("The Title Wadus", article.title)
    assert_equal("The Body Wadus Wadus Wadus Wadus", article.body)
    assert_equal(@front_user, article.front_user)
    assert_equal(["one", "two"], article.tag_list)
    assert article.pic.attached?
  end

  def test_edit
    article = FactoryBot.create(:article, front_user: @front_user)

    get :edit, params: { id: article }

    assert_template "edit"
    assert_equal(article, assigns(:article))
  end

  def test_update_invalid
    article = FactoryBot.create(:article, front_user: @front_user)

    Article.any_instance.stubs(:valid?).returns(false)

    put(
      :update,
      params: {
        id: article,
        article: {
          title: "The New Title"
        }
      }
    )

    assert_template "edit"
    assert_not_nil(flash[:alert])
  end

  def test_update_valid
    article = FactoryBot.create(:article, front_user: @front_user)

    put(
      :update,
      params: {
        id: article,
        article: {
          title: "The New Title"
        }
      }
    )

    assert_redirected_to [:front, article]
    assert_not_nil(flash[:notice])

    article.reload
    assert_equal("The New Title", article.title)
  end

  def test_destroy
    article = FactoryBot.create(:article, front_user: @front_user)

    delete :destroy, params: { id: article }

    assert_redirected_to :front_articles
    assert_not_nil(flash[:notice])

    assert !Article.exists?(article.id)
  end

  def test_edit_not_allowed
    front_user = FactoryBot.create(:front_user)
    article = FactoryBot.create(:article, front_user: front_user)

    get(
      :edit,
      params: {
        id: article
      }
    )

    assert_redirected_to [:front, article]
    assert_not_nil(flash[:alert])
  end

  def test_update_not_allowed
    front_user = FactoryBot.create(:front_user)
    article = FactoryBot.create(:article, front_user: front_user)

    put(
      :update,
      params: {
        id: article,
        article: {
          message: "The Wadus Message New"
        }
      }
    )

    assert_redirected_to [:front, article]
    assert_not_nil(flash[:alert])
  end

  def test_destroy_not_allowed
    front_user = FactoryBot.create(:front_user)
    article = FactoryBot.create(:article, front_user: front_user)

    delete(
      :destroy,
      params: {
        id: article
      }
    )

    assert_redirected_to [:front, article]
    assert_not_nil(flash[:alert])
  end
end
