class Front::FrontUsersController < Front::BaseController
  before_action :require_front_user, only: [:show, :edit, :update, :destroy]
  before_action :load_front_user, only: [:show, :edit, :update, :destroy]
  before_action :validate_current_front_user, only: [:show, :edit, :update, :destroy]

  def show; end

  def new
    @front_user = FrontUser.new
    render layout: "front/base_login"
  end

  def create
    @front_user = FrontUser.new(front_user_params)
    if @front_user.save
      redirect_to [:front, @front_user], notice: t("controllers.front_users.create.success")
    else
      flash.now[:alert] = t("controllers.front_users.create.error")
      render action: :new, layout: "front/base_login"
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

  def reset_password
    load_front_user_from_perishable_token

    render :reset_password
  end

  def reset_password_submit
    load_front_user_from_perishable_token

    if @front_user.update(front_user_params)
      AdminSession.create(@front_user)
      flash[:notice] = t("controllers.front_users.reset_password.success")
      redirect_back_or_default front_root_path
    else
      flash.now[:alert] = t("controllers.front_users.reset_password.error")
      render :reset_password
    end
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

  def load_front_user_from_perishable_token
    @front_user = FrontUser.find_using_perishable_token!(params[:reset_password_code], 1.week)
  end
end
