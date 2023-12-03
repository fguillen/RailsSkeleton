class Admin::UserNotificationsPrefsController < Admin::BaseController
  before_action :require_admin_user
  before_action :load_admin_user
  before_action :load_user_notifications_pref

  def edit; end

  def update
    if @user_notifications_pref.update(user_notifications_pref_params)
      redirect_to edit_admin_admin_user_user_notifications_pref_path(user_admin_id: @admin_user), notice: t("controllers.user_notifications_prefs.update.success")
    else
      flash.now[:alert] = t("controllers.user_notifications_prefs.update.error")
      render action: :edit
    end
  end

  protected

  def user_notifications_pref_params
    params[:user_notifications_pref][:active_notifications] = params[:user_notifications_pref][:active_notifications].compact_blank
    params.fetch(:user_notifications_pref, {}).permit(active_notifications: []).compact
  end

  private

  def load_user_notifications_pref
    @user_notifications_pref = @admin_user.user_notifications_pref
  end

  def load_admin_user
    @admin_user = AdminUser.find(params[:admin_user_id])
  end
end
