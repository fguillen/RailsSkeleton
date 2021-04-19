class Share::AuthorizationsController < ApplicationController
  def failure
    flash[:alert] = "You haven't authorized your Google account."
    redirect_to root_url
  end

  def blank # omniauth needs this method to handle the authentication process
    render :text => "Not Found", :status => 404
  end
end
