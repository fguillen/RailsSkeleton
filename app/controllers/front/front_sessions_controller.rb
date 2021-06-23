class Front::FrontSessionsController < Front::BaseController
  def new
    @front_session = FrontSession.new
  end

  def create
    @front_session = FrontSession.new(front_session_params.to_h)

    if @front_session.save
      flash[:notice] = t("controllers.front_sessions.authenticate.success")
      redirect_back_or_default front_root_path
    else
      flash[:alert] = t("controllers.front_sessions.authenticate.error")
      render action: :new
    end
  end

  def destroy
    @front_session = FrontSession.find
    @front_session&.destroy

    redirect_to front_login_path, notice: t("controllers.front_sessions.logout.success")
  end

  def forgot_password
    @front_session = FrontSession.new
  end

  def forgot_password_submit
    front_user = FrontUser.find_by_email(params[:front_session][:email])

    if front_user
      front_user.send_reset_password_email
      redirect_to front_forgot_password_path, notice: t("controllers.front_sessions.reset_password.success")
    else
      redirect_to front_forgot_password_path, alert: t("controllers.front_sessions.reset_password.error", email: params[:front_session][:email])
    end
  end

  protected

  def front_session_params
    params.require(:front_session).permit(:email, :password)
  end
end
