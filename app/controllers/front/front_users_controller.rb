class Front::FrontUsersController < Front::BaseController
  before_action :require_front_user, only: [:show, :edit, :update, :destroy]
  before_action :load_front_user, only: [:show, :edit, :update, :destroy]
  before_action :validate_current_front_user, only: [:show, :edit, :update, :destroy]

  def show; end

  def new
    @front_user = FrontUser.new
  end

  def create
    @front_user = FrontUser.new(front_user_params)
    if @front_user.save
      redirect_to [:front, @front_user], notice: t("controllers.front_users.create.success")
    else
      flash.now[:alert] = t("controllers.front_users.create.error")
      render action: :new
    end
  end

  def edit; end

  def update
    if @front_user.update(front_user_params)
      redirect_to [:front, @front_user], notice: t("controllers.front_users.update.success")
    else
      flash.now[:alert] = t("controllers.front_users.update.error")
      render action: :edit
    end
  end

  def destroy
    @front_user.destroy
    redirect_to :front_root, notice: t("controllers.front_users.destroy.success")
  end

  protected

  def front_user_params
    params.require(:front_user).permit(:name, :email, :password, :password_confirmation)
  end

  private

  def load_front_user
    @front_user = FrontUser.find(params[:id])
  end

  def validate_current_front_user
    if @front_user != current_front_user
      redirect_to :front_root, alert: t("controllers.front.access_not_authorized")
      false
    end
  end
end
