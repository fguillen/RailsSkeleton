class Notifications::Front::Mailer < ActionMailer::Base
  default from: APP_CONFIG["admin_email"]
  layout "layouts/mailer"

  def on_new_article(front_user, article)
    @article = article
    @article_link = front_article_url(@article, host: APP_CONFIG["host"])

    mail(
      to: front_user.email,
      subject: "[RailsSkeleton] New Article: #{@article.title}"
    )
  end
end
