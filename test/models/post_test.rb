require "test_helper"

class PostTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:post).valid?
  end

  def test_validations
    post = FactoryBot.build(:post)
    assert(post.valid?)

    post = FactoryBot.build(:post, title: nil)
    refute(post.valid?)

    post = FactoryBot.build(:post, body: nil)
    refute(post.valid?)

    post = FactoryBot.build(:post, body: "")
    refute(post.valid?)

    post = FactoryBot.build(:post, body: "A" * 6)
    refute(post.valid?)

    post = FactoryBot.build(:post, body: "A" * 501)
    refute(post.valid?)

    post = FactoryBot.build(:post, body: "A" * 30)
    assert(post.valid?)

    post = FactoryBot.build(:post, front_user: nil)
    refute(post.valid?)
  end

  def test_uuid_on_create
    post = FactoryBot.build(:post)
    assert_nil(post.uuid)

    post.save!

    assert_not_nil(post.uuid)
  end

  def test_primary_key
    post = FactoryBot.create(:post)

    assert_equal(post, Post.find(post.uuid))
  end

  def test_relations
    front_user = FactoryBot.create(:front_user)

    post = FactoryBot.create(:post, front_user: front_user)

    assert_equal(front_user, post.front_user)
  end
end
