class Api::Admin::AdminUsersController < Api::Admin::ApiController
  rescue_from StandardError, with: :show_errors

  def index
    @admin_users = AdminUser.all.order_by_recent

    render json: @admin_users.map { |admin_user| filter_returned_parameters(admin_user) }
  end

  private

  def fetch_admin_user
    @admin_user = AdminUser.find_by!(uuid: params[:uuid])
  end

  def filter_returned_parameters(admin_user)
    admin_user.slice("name")
  end

  def show_errors(exception)
    render json: { errors: [exception.message] }, status: :unprocessable_entity
  end
end
