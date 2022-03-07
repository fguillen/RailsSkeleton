require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:article).valid?
  end

  def test_validations
    article = FactoryBot.build(:article)
    assert(article.valid?)

    article = FactoryBot.build(:article, title: nil)
    refute(article.valid?)

    article = FactoryBot.build(:article, body: nil)
    refute(article.valid?)

    article = FactoryBot.build(:article, body: "")
    refute(article.valid?)

    article = FactoryBot.build(:article, body: "A" * 6)
    refute(article.valid?)

    article = FactoryBot.build(:article, body: "A" * 65_536)
    refute(article.valid?)

    article = FactoryBot.build(:article, body: "A" * 30)
    assert(article.valid?)

    article = FactoryBot.build(:article, front_user: nil)
    refute(article.valid?)
  end

  def test_uuid_on_create
    article = FactoryBot.build(:article)
    assert_nil(article.uuid)

    article.save!

    assert_not_nil(article.uuid)
  end

  def test_primary_key
    article = FactoryBot.create(:article)

    assert_equal(article, Article.find(article.uuid))
  end

  def test_relations
    front_user = FactoryBot.create(:front_user)

    article = FactoryBot.create(:article, front_user: front_user)

    assert_equal(front_user, article.front_user)
  end

  def test_tags
    article = FactoryBot.create(:article, tag_list: ["one", "two"])
    assert_equal(2, article.tags.count)
    assert_equal(["one", "two"], article.tag_list)
    assert_equal(["one", "two"], article.tags.map(&:name))

    article = FactoryBot.create(:article, tag_list: "one, two")
    assert_equal(2, article.tags.count)
    assert_equal(["one", "two"], article.tag_list)
    assert_equal(["one", "two"], article.tags.map(&:name))

    article = FactoryBot.create(:article, tag_list: "One, Two")
    assert_equal(["one", "two"], article.tag_list)
  end

  def test_log_book_events
    front_user = FactoryBot.create(:front_user)
    article = FactoryBot.build(:article, title: "TITLE", front_user: front_user)

    assert_difference("LogBook::Event.count", 1) do
      article.save!
    end

    assert_difference("LogBook::Event.count", 1) do
      article.update!(title: "NEW_TITLE")
    end
  end
end
