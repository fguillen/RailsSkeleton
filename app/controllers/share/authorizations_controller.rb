class Share::AuthorizationsController < ApplicationController
  def failure
    flash[:alert] = "You haven't authorized your Google account."
    redirect_to root_url
  end

  # omniauth needs this method to handle the authentication process
  def blank
    render text: "Not Found", status: 404
  end
end
