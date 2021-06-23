class Front::PagesController < Front::BaseController
  def show
    raise ActionController::RoutingError, "Not Found" if params[:id].nil?

    render "front/pages/#{show_params[:id]}"
  end

  private

  def show_params
    params.permit(:id)
  end
end
