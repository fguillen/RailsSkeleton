class Admin::BaseController < ApplicationController
  include Admin::BaseHelper

  layout "/admin/base"

  helper_method :current_admin_user, :namespace

  private

  def require_admin_user
    unless current_admin_user
      store_location
      flash[:alert] = t("controllers.admin.authentication_required")
      redirect_to admin_login_path
      return false
    end
  end

  def current_admin_session
    return @current_admin_session if defined?(@current_admin_session)
    @current_admin_session = AdminSession.find
  end

  def current_admin_user
    return @current_admin_user if defined?(@current_admin_user)
    @current_admin_user = current_admin_session && current_admin_session.record
  end

  def store_location
    session[:back_return_to] = request.url
  end

  def redirect_back_or_default( default )
    redirect_to(session[:back_return_to] || default)
    session[:back_return_to] = nil
  end
end
