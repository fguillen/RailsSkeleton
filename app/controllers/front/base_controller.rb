class Front::BaseController < ApplicationController
  include Front::BaseHelper

  layout "/front/base"

  helper_method :current_front_user, :namespace

  private

  def require_front_user
    unless current_front_user
      store_location
      flash[:alert] = t("controllers.front.authentication_required")
      redirect_to front_login_path
      return false
    end
  end

  def current_front_user_session
    return @current_front_user_session if defined?(@current_front_user_session)

    @current_front_user_session = FrontSession.find
  end

  def current_front_user
    return @current_front_user if defined?(@current_front_user)

    @current_front_user = current_front_user_session && current_front_user_session.record
  end

  def store_location
    session[:front_return_to] = request.url
  end

  def redirect_back_or_default(default)
    redirect_to(session[:front_return_to] || default)
    session[:front_return_to] = nil
  end
end
