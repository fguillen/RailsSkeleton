class Front::FrontSessionsController < Front::BaseController
  layout "front/base_basic"

  def new
    @front_session = FrontSession.new
  end

  def destroy
    @front_session = FrontSession.find
    @front_session&.destroy

    redirect_to :root, notice: t("controllers.front_sessions.logout.success")
  end
end
