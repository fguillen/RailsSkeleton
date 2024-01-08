class Notifier < ActionMailer::Base
  default from: APP_CONFIG["admin_email"]
  layout "layouts/mailer"

  def admin_user_reset_password(admin_user)
    @reset_password_link = admin_reset_password_url(admin_user.perishable_token, host: APP_CONFIG["host"])

    mail(
      to: admin_user.email,
      subject: "[RailsSkeleton] Password reset"
    )
  end

  def front_user_reset_password(front_user)
    @reset_password_link = front_reset_password_url(front_user.perishable_token, host: APP_CONFIG["host"])

    mail(
      to: front_user.email,
      subject: "[RailsSkeleton] Password reset"
    )
  end

  def simple_test_email(subject, to)
    mail(
      to: to,
      subject: "[RailsSkeleton] #{subject}"
    )
  end
end
