class Admin::AdminAuthorizationsController < Admin::BaseController
  before_action :require_admin_user, :only => [:destroy]

  def create
    omniauth_data = request.env['omniauth.auth'] # Google response with user data
    authorization = AdminAuthorization.find_from_omniauth_data(omniauth_data) # Look for a previous authorization

    if authorization # User was already autenticated with Google, log the user in
      flash[:notice] = "Welcome back #{authorization.admin_user.name}"
      AdminSession.create(authorization.admin_user, true)
      redirect_back_or_default admin_root_path
    else # First authentication with google, check for email correspondence
      admin_user = AdminUser.find_by_email omniauth_data[:info][:email]

      if admin_user # Admin with Google email found, create authentication record and log the user in
        admin_user.authorizations.create({ :provider => omniauth_data['provider'], :uid => omniauth_data['uid'] })
        AdminSession.create(admin_user, true)
        flash[:notice] = "Welcome #{admin_user.name}"
        redirect_back_or_default admin_root_path
      else # No email correspondence found, user rejected
        flash[:alert] = "You are not authorized to access this resource"
        redirect_to :admin_login
      end
    end
  end
end
