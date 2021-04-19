class Notifier < ActionMailer::Base
  default :from => APP_CONFIG[:admin_email]

  def admin_user_reset_password(admin_user)
    @reset_password_link = admin_reset_password_url(admin_user.perishable_token, :host => APP_CONFIG[:hosts].first)

    mail(
      :to => admin_user.email,
      :subject => "[ScrapStats] Password reset"
    )
  end
end
