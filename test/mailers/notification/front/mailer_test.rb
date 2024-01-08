require "test_helper"

class Front::UserMailerTest < ActionMailer::TestCase
  def test_on_new_article
    front_user = FactoryBot.create(:front_user, email: "front@email.com")
    article = FactoryBot.create(:article, title: "NEW_ARTICLE")

    email = Notification::Front::Mailer.on_new_article(front_user, article).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal ["it@railsskeleton.com"], email.from
    assert_equal ["front@email.com"], email.to
    assert_equal "[RailsSkeleton] New Article: NEW_ARTICLE", email.subject

    # write_fixture("/notification/front/on_new_article.txt", email.body.encoded)
    assert_equal(File.read(fixture("/notification/front/on_new_article.txt")), email.body.encoded)
  end
end
