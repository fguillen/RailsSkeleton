require "test_helper"

class Admin::UserMailerTest < ActionMailer::TestCase
  def test_on_new_article
    admin_user = FactoryBot.create(:admin_user, email: "admin@email.com")
    article = FactoryBot.create(:article, title: "NEW_ARTICLE")

    email = Admin::UserMailer.on_new_article(admin_user, article).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal ["it@railsskeleton.com"], email.from
    assert_equal ["admin@email.com"], email.to
    assert_equal "[RailsSkeleton] New Article: NEW_ARTICLE", email.subject

    # write_fixture("/notifier/admin/on_new_article.txt", email.body.encoded)
    assert_equal(File.read(fixture("/notifier/admin/on_new_article.txt")), email.body.encoded)
  end
end
