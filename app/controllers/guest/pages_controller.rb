class Guest::PagesController < Guest::BaseController
  def show
    raise ActionController::RoutingError, "Not Found" if params[:id].nil?

    render "guest/pages/#{show_params[:id]}"
  end

  private

  def show_params
    params.permit(:id)
  end
end
