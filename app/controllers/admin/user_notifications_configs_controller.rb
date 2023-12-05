class Admin::UserNotificationsConfigsController < Admin::BaseController
  before_action :require_admin_user
  before_action :load_user_notifications_config, only: [:edit]

  def edit; end

  def update
    # Rails.logger.debug "params: #{user_notifications_config_params.inspect}"
    if @user_notifications_config.update(user_notifications_config_params)
      redirect_to [:admin, @user_notifications_config], notice: t("controllers.user_notifications_configs.update.success")
    else
      flash.now[:alert] = t("controllers.user_notifications_configs.update.error")
      render action: :edit
    end
  end

  protected

  def user_notifications_config_params
    params.require(:user_notifications_config).permit(active_notifications: [])
  end

  private

  def load_user_notifications_config
    @user_notifications_config = UserNotificationsConfig.find(params[:id])
  end
end
