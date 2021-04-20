class Admin::FrontUsersController < Admin::BaseController
  before_action :require_admin_user
  before_action :load_front_user, only: [:show, :edit, :update, :destroy]

  def index
    @front_users = FrontUser.order_by_recent
  end

  def show; end

  def new
    @front_user = FrontUser.new
  end

  def create
    @front_user = FrontUser.new(front_user_params)
    if @front_user.save
      redirect_to [:admin, @front_user], notice: t("controllers.front_users.create.success")
    else
      flash.now[:alert] = t("controllers.front_users.create.error")
      render action: :new
    end
  end

  def edit; end

  def update
    if @front_user.update(front_user_params)
      redirect_to [:admin, @front_user], notice: t("controllers.front_users.update.success")
    else
      flash.now[:alert] = t("controllers.front_users.update.error")
      render action: :edit
    end
  end

  def destroy
    @front_user.destroy
    redirect_to :admin_front_users, notice: t("controllers.front_users.destroy.success")
  end

  protected

  def front_user_params
    params.require(:front_user).permit(:name, :email)
  end

  private

  def load_front_user
    @front_user = FrontUser.find(params[:id])
  end
end
