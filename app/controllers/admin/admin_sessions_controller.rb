class Admin::AdminSessionsController < Admin::BaseController
  layout "admin/base_login"

  def new
    @admin_session = AdminSession.new
  end

  def create
    @admin_session = AdminSession.new(admin_session_params.to_h)

    if @admin_session.save
      flash[:notice] = t("controllers.admin_sessions.authenticate.success")
      redirect_back_or_default admin_root_path
    else
      flash[:alert] = t("controllers.admin_sessions.authenticate.error")
      render action: :new
    end
  end

  def destroy
    @admin_session = AdminSession.find
    @admin_session&.destroy

    redirect_to admin_login_path, notice: t("controllers.admin_sessions.logout.success")
  end

  def forgot_password
    @admin_session = AdminSession.new
  end

  def forgot_password_submit
    admin_user = AdminUser.find_by_email(params[:admin_session][:email])

    if admin_user
      admin_user.send_reset_password_email
      redirect_to admin_forgot_password_path, notice: t("controllers.admin_sessions.forgot_password_submit.success")
    else
      redirect_to admin_forgot_password_path, alert: t("controllers.admin_sessions.forgot_password_submit.error", email: params[:admin_session][:email])
    end
  end

  protected

  def admin_session_params
    params.require(:admin_session).permit(:email, :password)
  end
end
