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

    post = FactoryBot.build(:post, body: "A" * 65_536)
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

  def test_tags
    post = FactoryBot.create(:post, tag_list: ["one", "two"])
    assert_equal(2, post.tags.count)
    assert_equal(["one", "two"], post.tag_list)
    assert_equal(["one", "two"], post.tags.map(&:name))

    post = FactoryBot.create(:post, tag_list: "one, two")
    assert_equal(2, post.tags.count)
    assert_equal(["one", "two"], post.tag_list)
    assert_equal(["one", "two"], post.tags.map(&:name))

    post = FactoryBot.create(:post, tag_list: "One, Two")
    assert_equal(["one", "two"], post.tag_list)
  end

  def test_log_book_events
    front_user = FactoryBot.create(:front_user)
    post = FactoryBot.build(:post, title: "TITLE", front_user: front_user)

    assert_difference("LogBook::Event.count", 1) do
      post.save!
    end

    assert_difference("LogBook::Event.count", 1) do
      post.update!(title: "NEW_TITLE")
    end
  end
end
