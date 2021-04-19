require "test_helper"

class Admin::PostsControllerTest < ActionController::TestCase
  def setup
    setup_admin_user
  end

  def test_index
    post_1 = FactoryBot.create(:post, created_at: "2020-04-25")
    post_2 = FactoryBot.create(:post, created_at: "2020-04-26")

    get :index

    assert_template "admin/posts/index"
    assert_primary_keys([post_2, post_1], assigns(:posts))
  end

  def test_show
    post = FactoryBot.create(:post)

    get :show, params: { id: post }

    assert_template "admin/posts/show"
    assert_equal(post, assigns(:post))
  end

  def test_new
    get :new
    assert_template "admin/posts/new"
    assert_not_nil(assigns(:post))
  end

  def test_create_invalid
    front_user_1 = FactoryBot.create(:front_user)

    Post.any_instance.stubs(:valid?).returns(false)

    post(
      :create,
      params: {
        post: {
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
        post: {
          front_user_id: front_user_1,
          title: "The Title Wadus",
          body: "Wadus Message longer than 20 chars",
        }
      }
    )

    post = Post.last
    assert_redirected_to [:admin, post]

    assert_equal("The Title Wadus", post.title)
    assert_equal(front_user_1, post.front_user)
  end

  def test_edit
    post = FactoryBot.create(:post)

    get :edit, params: { id: post }

    assert_template "edit"
    assert_equal(post, assigns(:post))
  end

  def test_update_invalid
    post = FactoryBot.create(:post)

    Post.any_instance.stubs(:valid?).returns(false)

    put(
      :update,
      params: {
        id: post,
        post: {
          title: "The Wadus Message New"
        }
      }
    )

    assert_template "edit"
    assert_not_nil(flash[:alert])
  end

  def test_update_valid
    post = FactoryBot.create(:post)

    put(
      :update,
      params: {
        id: post,
        post: {
          title: "The Wadus Message New"
        }
      }
    )

    assert_redirected_to [:admin, post]
    assert_not_nil(flash[:notice])

    post.reload
    assert_equal("The Wadus Message New", post.title)
  end

  def test_destroy
    post = FactoryBot.create(:post)

    delete :destroy, params: { id: post }

    assert_redirected_to :admin_posts
    assert_not_nil(flash[:notice])

    assert !Post.exists?(post.id)
  end
end
