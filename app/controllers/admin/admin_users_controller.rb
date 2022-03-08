class Admin::AdminUsersController < Admin::BaseController
  before_action :require_admin_user, except: [:reset_password, :reset_password_submit]
  before_action :load_admin_user, only: [:show, :edit, :update, :destroy]

  def index
    @admin_users = AdminUser.order_by_recent
  end

  def show; end

  def new
    @admin_user = AdminUser.new
    render layout: "admin/base_login"
  end

  def create
    @admin_user = AdminUser.new(admin_user_params)
    if @admin_user.save
      redirect_to [:admin, @admin_user], notice: t("controllers.admin_users.create.success")
    else
      flash.now[:alert] = t("controllers.admin_users.create.error")
      render action: :new, layout: "admin/base_login"
    end
  end

  def edit; end

  def update
    if @admin_user.update(admin_user_params)
      redirect_to [:admin, @admin_user], notice: t("controllers.admin_users.update.success")
    else
      flash.now[:alert] = t("controllers.admin_users.update.error")
      render action: :edit
    end
  end

  def destroy
    @admin_user.destroy
    redirect_to :admin_admin_users, notice: t("controllers.admin_users.destroy.success")
  end

  def reset_password
    load_admin_user_from_perishable_token

    render :reset_password, layout: "admin/base_login"
  end

  def reset_password_submit
    load_admin_user_from_perishable_token

    if @admin_user.update(admin_user_params)
      AdminSession.create(@admin_user)
      flash[:notice] = t("controllers.admin_users.reset_password.success")
      redirect_back_or_default admin_root_path
    else
      flash.now[:alert] = t("controllers.admin_users.reset_password.error")
      render :reset_password, layout: "admin/base_login"
    end
  end

  protected

  def admin_user_params
    params.require(:admin_user).permit(:name, :email, :password, :password_confirmation, :uuid)
  end

  private

  def load_admin_user
    @admin_user = AdminUser.find(params[:id])
  end

  def load_admin_user_from_perishable_token
    @admin_user = AdminUser.find_using_perishable_token!(params[:reset_password_code], 1.week)
  end
end
