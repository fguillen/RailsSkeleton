class Admin::AppreciableUsersController < Admin::BaseController
  before_action :require_admin_user
  before_action :load_appreciable_user, :only => [:show, :edit, :update, :destroy]

  def index
    @appreciable_users = AppreciableUser.order_by_recent
  end

  def show
  end

  def new
    @appreciable_user = AppreciableUser.new
  end

  def create
    @appreciable_user = AppreciableUser.new(appreciable_user_params)
    if @appreciable_user.save
      redirect_to [:admin, @appreciable_user], :notice => t("controllers.appreciable_users.create.success")
    else
      flash.now[:alert] = t("controllers.appreciable_users.create.error")
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @appreciable_user.update(appreciable_user_params)
      redirect_to [:admin, @appreciable_user], :notice  => t("controllers.appreciable_users.update.success")
    else
      flash.now[:alert] = t("controllers.appreciable_users.update.error")
      render :action => :edit
    end
  end

  def destroy
    @appreciable_user.destroy
    redirect_to :admin_appreciable_users, :notice => t("controllers.appreciable_users.destroy.success")
  end

protected

  def appreciable_user_params
    params.require(:appreciable_user).permit(:name, :email)
  end

private

  def load_appreciable_user
    @appreciable_user = AppreciableUser.find(params[:id])
  end
end
