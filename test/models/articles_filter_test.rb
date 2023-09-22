require "test_helper"

class ArticlesFilterTest < ActiveSupport::TestCase
  def test_initialize
    articles_filter =
      ArticlesFilter.new(
        title: "TITLE",
        tags: ["tag1", "tag2"],
        tags_mode: "all",
        created_at_from: "2023-09-20",
        created_at_to: "2023-09-21",
        front_user_name: "NAME",
      )

    assert_equal "TITLE", articles_filter.title
    assert_equal ["tag1", "tag2"], articles_filter.tags
    assert_equal "all", articles_filter.tags_mode
    assert_equal "2023-09-20", articles_filter.created_at_from.to_fs(:datedb)
    assert_equal "2023-09-21", articles_filter.created_at_to.to_fs(:datedb)
    assert_equal "NAME", articles_filter.front_user_name
  end

  def test_initialize_defaults
    articles_filter = ArticlesFilter.new()
    assert_nil(articles_filter.title)
    assert_equal([], articles_filter.tags)
    assert_equal("any", articles_filter.tags_mode)
    assert_nil(articles_filter.created_at_from)
    assert_nil(articles_filter.created_at_to)
    assert_nil(articles_filter.front_user_name)
  end

  # def test_initialize_strip_attributes
  #   articles_filter =
  #     ArticlesFilter.new(
  #       title: "",
  #       tags: nil,
  #       tags_mode: "",
  #       created_at_from: "",
  #       created_at_to: "",
  #       front_user_name: "",
  #     )

  #   assert_nil(articles_filter.title)
  #   assert_equal([], articles_filter.tags)
  #   assert_equal("any", articles_filter.tags_mode)
  #   assert_nil(articles_filter.created_at_from)
  #   assert_nil(articles_filter.created_at_to)
  #   assert_nil(articles_filter.front_user_name)
  # end

  def test_validations
    articles_filter = ArticlesFilter.new()
    assert articles_filter.valid?

    articles_filter.created_at_from = "2023-09-21"
    assert articles_filter.valid?

    articles_filter.created_at_to = "2023-09-22"
    assert articles_filter.valid?

    articles_filter.created_at_to = "2023-09-20"
    refute articles_filter.valid?
  end

  def test_filter_by_title
    article_1 = FactoryBot.create(:article, title: "TITLE 1", uuid: "UUID_1")
    article_2 = FactoryBot.create(:article, title: "TITLE 2", uuid: "UUID_2")
    article_3 = FactoryBot.create(:article, title: "TITLE 3", uuid: "UUID_3")

    articles_filter_1 = ArticlesFilter.new(title: "TITLE_1")
    articles_filter_2 = ArticlesFilter.new(title: "TITLE")

    assert_primary_keys([article_1], articles_filter_1.filter)
    assert_primary_keys([article_1, article_2, article_3], articles_filter_2.filter.order("uuid asc"))
  end

  def test_filter_by_tags_mode_all
    article_1 = FactoryBot.create(:article, uuid: "UUID_1", tag_list: "tag_1")
    article_2 = FactoryBot.create(:article, uuid: "UUID_2", tag_list: "tag_1, tag_2")
    article_3 = FactoryBot.create(:article, uuid: "UUID_3", tag_list: "tag_1, tag_3")
    article_4 = FactoryBot.create(:article, uuid: "UUID_4", tag_list: "tag_1, tag_2")
    article_5 = FactoryBot.create(:article, uuid: "UUID_5", tag_list: "tag_1, tag_2, tag_3")

    articles_filter_1 = ArticlesFilter.new(tags: "tag_1", tags_mode: "all")
    articles_filter_2 = ArticlesFilter.new(tags: "tag_1, tag_2", tags_mode: "all")

    assert_primary_keys([article_1], articles_filter_1.filter.order("uuid asc"))
    assert_primary_keys([article_2, article_4], articles_filter_2.filter.order("uuid asc"))
  end

  def test_filter_by_tags_mode_any
    article_1 = FactoryBot.create(:article, uuid: "UUID_1", tag_list: "tag_1")
    article_2 = FactoryBot.create(:article, uuid: "UUID_2", tag_list: "tag_1, tag_2")
    article_3 = FactoryBot.create(:article, uuid: "UUID_3", tag_list: "tag_1, tag_3")
    article_4 = FactoryBot.create(:article, uuid: "UUID_4", tag_list: "tag_1, tag_2")

    articles_filter_1 = ArticlesFilter.new(tags: "tag_1", tags_mode: "any")
    articles_filter_2 = ArticlesFilter.new(tags: "tag_2, tag_3", tags_mode: "any")

    assert_primary_keys([article_1, article_2, article_3, article_4], articles_filter_1.filter.order("uuid asc"))
    assert_primary_keys([article_2, article_3, article_4], articles_filter_2.filter.order("uuid asc"))
  end

  # def test_filter_by_tags_mode_exclude
  #   article_1 = FactoryBot.create(:article, uuid: "UUID_1", tag_list: "tag_1")
  #   article_2 = FactoryBot.create(:article, uuid: "UUID_2", tag_list: "tag_1, tag_2")
  #   article_3 = FactoryBot.create(:article, uuid: "UUID_3", tag_list: "tag_1, tag_3")
  #   article_4 = FactoryBot.create(:article, uuid: "UUID_4", tag_list: "tag_1, tag_2")

  #   articles_filter_1 = ArticlesFilter.new(tags: "tag_1", tags_mode: "exclude")
  #   articles_filter_2 = ArticlesFilter.new(tags: "tag_2, tag_3", tags_mode: "exclude")

  #   assert(articles_filter_1.filter.empty?)
  #   assert_primary_keys([article_1], articles_filter_2.filter.order("uuid asc"))
  # end

  def test_filter_by_created_at_from
    article_1 = FactoryBot.create(:article, uuid: "UUID_1", created_at: "2023-09-20")
    article_2 = FactoryBot.create(:article, uuid: "UUID_2", created_at: "2023-09-21")

    articles_filter_1 = ArticlesFilter.new(created_at_from: "2023-09-20")
    articles_filter_2 = ArticlesFilter.new(created_at_from: "2023-09-21")
    articles_filter_3 = ArticlesFilter.new(created_at_from: "2023-09-22")

    assert_primary_keys([article_1, article_2], articles_filter_1.filter.order("uuid asc"))
    assert_primary_keys([article_2], articles_filter_2.filter.order("uuid asc"))
    assert_primary_keys([], articles_filter_3.filter.order("uuid asc"))
  end

  def test_filter_by_created_at_to
    article_1 = FactoryBot.create(:article, uuid: "UUID_1", created_at: "2023-09-20")
    article_2 = FactoryBot.create(:article, uuid: "UUID_2", created_at: "2023-09-21")

    articles_filter_1 = ArticlesFilter.new(created_at_to: "2023-09-20")
    articles_filter_2 = ArticlesFilter.new(created_at_to: "2023-09-21")
    articles_filter_3 = ArticlesFilter.new(created_at_to: "2023-09-19")

    assert_primary_keys([article_1], articles_filter_1.filter.order("uuid asc"))
    assert_primary_keys([article_1, article_2], articles_filter_2.filter.order("uuid asc"))
    assert_primary_keys([], articles_filter_3.filter.order("uuid asc"))
  end

  def test_filter_by_created_at_from_and_created_at_to
    article_1 = FactoryBot.create(:article, uuid: "UUID_1", created_at: "2023-09-20")
    article_2 = FactoryBot.create(:article, uuid: "UUID_2", created_at: "2023-09-21")
    article_3 = FactoryBot.create(:article, uuid: "UUID_3", created_at: "2023-09-22 23:59")

    articles_filter_1 = ArticlesFilter.new(created_at_from: "2023-09-20", created_at_to: "2023-09-20")
    articles_filter_2 = ArticlesFilter.new(created_at_from: "2023-09-21", created_at_to: "2023-09-22")
    articles_filter_3 = ArticlesFilter.new(created_at_from: "2023-09-23", created_at_to: "2023-09-24")

    assert_primary_keys([article_1], articles_filter_1.filter.order("uuid asc"))
    assert_primary_keys([article_2, article_3], articles_filter_2.filter.order("uuid asc"))
    assert_primary_keys([], articles_filter_3.filter.order("uuid asc"))
  end

  def test_filter_by_front_user_name
    front_user_1 = FactoryBot.create(:front_user, name: "NAME_1", email: "email_1@example.com")
    front_user_2 = FactoryBot.create(:front_user, name: "NAME_2", email: "email_2@example.com")

    article_1 = FactoryBot.create(:article, uuid: "UUID_1", front_user: front_user_1)
    article_2 = FactoryBot.create(:article, uuid: "UUID_2", front_user: front_user_2)
    article_3 = FactoryBot.create(:article, uuid: "UUID_3", front_user: front_user_2)

    articles_filter_1 = ArticlesFilter.new(front_user_name: "NAME_1")
    articles_filter_2 = ArticlesFilter.new(front_user_name: "email")
    articles_filter_3 = ArticlesFilter.new(front_user_name: "name_1")

    assert_primary_keys([article_1], articles_filter_1.filter.order("uuid asc"))
    assert_primary_keys([article_1, article_2, article_3], articles_filter_2.filter.order("uuid asc"))
    assert_primary_keys([article_1], articles_filter_3.filter.order("uuid asc"))
  end

  def test_filter_by_combination
    front_user_1 = FactoryBot.create(:front_user, name: "NAME_1", email: "email_1@example.com")

    article_1 = FactoryBot.create(:article, uuid: "UUID_1", created_at: "2023-09-20", tag_list: "tag_1, tag_2", title: "TITLE_1", front_user: front_user_1)
    article_2 = FactoryBot.create(:article, uuid: "UUID_2", created_at: "2023-09-21", title: "TITLE_2")

    articles_filter_1 = ArticlesFilter.new(created_at_from: "2023-09-20", title: "TITLE", tags: "tag_1", front_user_name: "NAME")

    assert_primary_keys([article_1], articles_filter_1.filter.order("uuid asc"))
  end
end
