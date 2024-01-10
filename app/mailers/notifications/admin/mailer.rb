class Notifications::Admin::Mailer < ActionMailer::Base
  default from: APP_CONFIG["admin_email"]
  layout "layouts/mailer"

  def on_new_article(admin_user, article)
    @article = article
    @article_link = admin_article_url(@article, host: APP_CONFIG["host"])

    mail(
      to: admin_user.email,
      subject: "[RailsSkeleton] New Article: #{@article.title}"
    )
  end
end
