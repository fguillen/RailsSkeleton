class Front::BaseController < ApplicationController
  include Front::BaseHelper

  layout "/front/base"

  helper_method :current_appreciable_user, :namespace

  private

  def require_appreciable_user
    unless current_appreciable_user
      store_location
      flash[:alert] = t("controllers.front.authentication_required")
      redirect_to front_login_path
      return false
    end
  end

  def current_appreciable_user_session
    return @current_appreciable_user_session if defined?(@current_appreciable_user_session)
    @current_appreciable_user_session = AppreciableSession.find
  end

  def current_appreciable_user
    return @current_appreciable_user if defined?(@current_appreciable_user)
    @current_appreciable_user = current_appreciable_user_session && current_appreciable_user_session.record
  end

  def store_location
    session[:front_return_to] = request.url
  end

  def redirect_back_or_default( default )
    redirect_to(session[:front_return_to] || default)
    session[:front_return_to] = nil
  end
end
