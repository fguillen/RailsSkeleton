require "test_helper"

class Front::PostsControllerTest < ActionController::TestCase
  def setup
    setup_front_user
  end

  def test_index
    post_1 = FactoryBot.create(:post, created_at: "2020-04-25")
    post_2 = FactoryBot.create(:post, created_at: "2020-04-26")

    get :index

    assert_template "front/posts/index"
    assert_primary_keys([post_2, post_1], assigns(:posts))
  end

  def test_show
    post = FactoryBot.create(:post)

    get :show, params: { id: post }

    assert_template "front/posts/show"
    assert_equal(post, assigns(:post))
  end

  def test_new
    get :new
    assert_template "front/posts/new"
    assert_not_nil(assigns(:post))
  end

  def test_create_invalid
    front_user_1 = FactoryBot.create(:front_user)

    Post.any_instance.stubs(:valid?).returns(false)

    post(
      :create,
      params: {
        post: {
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
        post: {
          title: "The Title Wadus",
          body: "The Body Wadus Wadus Wadus Wadus",
          tag_list: "one, two",
          pic: fixture_file_upload("yourule.png")
        }
      }
    )

    post = Post.last
    assert_redirected_to [:front, post]

    assert_equal("The Title Wadus", post.title)
    assert_equal("The Body Wadus Wadus Wadus Wadus", post.body)
    assert_equal(@front_user, post.front_user)
    assert_equal(["one", "two"], post.tag_list)
    assert post.pic.attached?
  end

  def test_edit
    post = FactoryBot.create(:post, front_user: @front_user)

    get :edit, params: { id: post }

    assert_template "edit"
    assert_equal(post, assigns(:post))
  end

  def test_update_invalid
    post = FactoryBot.create(:post, front_user: @front_user)

    Post.any_instance.stubs(:valid?).returns(false)

    put(
      :update,
      params: {
        id: post,
        post: {
          title: "The New Title"
        }
      }
    )

    assert_template "edit"
    assert_not_nil(flash[:alert])
  end

  def test_update_valid
    post = FactoryBot.create(:post, front_user: @front_user)

    put(
      :update,
      params: {
        id: post,
        post: {
          title: "The New Title"
        }
      }
    )

    assert_redirected_to [:front, post]
    assert_not_nil(flash[:notice])

    post.reload
    assert_equal("The New Title", post.title)
  end

  def test_destroy
    post = FactoryBot.create(:post, front_user: @front_user)

    delete :destroy, params: { id: post }

    assert_redirected_to :front_posts
    assert_not_nil(flash[:notice])

    assert !Post.exists?(post.id)
  end

  def test_edit_not_allowed
    front_user = FactoryBot.create(:front_user)
    post = FactoryBot.create(:post, front_user: front_user)

    get(
      :edit,
      params: {
        id: post
      }
    )

    assert_redirected_to [:front, post]
    assert_not_nil(flash[:alert])
  end

  def test_update_not_allowed
    front_user = FactoryBot.create(:front_user)
    post = FactoryBot.create(:post, front_user: front_user)

    put(
      :update,
      params: {
        id: post,
        post: {
          message: "The Wadus Message New"
        }
      }
    )

    assert_redirected_to [:front, post]
    assert_not_nil(flash[:alert])
  end

  def test_destroy_not_allowed
    front_user = FactoryBot.create(:front_user)
    post = FactoryBot.create(:post, front_user: front_user)

    delete(
      :destroy,
      params: {
        id: post
      }
    )

    assert_redirected_to [:front, post]
    assert_not_nil(flash[:alert])
  end
end
