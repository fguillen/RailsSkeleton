class Api::Admin::AdminUsersController < Api::Admin::ApiController
  before_action :fetch_admin_user, :only => [:show, :destroy, :update]
  rescue_from StandardError, with: :show_errors

  def index
    @admin_users = AdminUser.all

    render json: @admin_users.map { |admin_user| filter_returned_parameters(admin_user) }
  end

  def show
    render json: filter_returned_parameters(@admin_user)
  end

  def create
    AdminUser.create!(admin_user_params)

    head :created
  end

  def update
    @admin_user.update!(admin_user_params)

    render json: filter_returned_parameters(@admin_user)
  end

  def destroy
    @admin_user.destroy!
  end

  private

  def admin_user_params
    params.require(:admin_user).permit(:email, :name, :password, :password_confirmation)
  end

  def fetch_admin_user
    @admin_user = AdminUser.find_by!(uuid: params[:uuid])
  end

  def filter_returned_parameters(admin_user)
    admin_user.slice('id', 'uuid', 'email', 'name')
  end

  def show_errors(exception)
    render json: { errors: [exception.message] }, status: :unprocessable_entity
  end
end

