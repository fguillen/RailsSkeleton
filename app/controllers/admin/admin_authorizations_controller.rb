class Admin::AdminAuthorizationsController < Admin::BaseController
  def create
    omniauth_data = request.env["omniauth.auth"] # Google response with user data
    authorization = AdminAuthorization.find_from_omniauth_data(omniauth_data) # Look for a previous authorization
    omniauth_params = request.env["omniauth.params"]

    if authorization # User was already authenticated with Google, log the user in
      flash[:notice] = "Welcome back #{authorization.admin_user.name}"
      AdminSession.create(authorization.admin_user, true)
      redirect_back_or_default admin_root_path
    else # First authentication with google, check for email correspondence
      admin_user = AdminUser.find_by_email omniauth_data[:info][:email]

      if admin_user # Admin with Google email found, create authentication record and log the user in
        AdminAuthorization.create(admin_user: admin_user, omniauth_data: omniauth_data, omniauth_params: omniauth_params)
        AdminSession.create(admin_user, true)
        flash[:notice] = "Welcome #{admin_user.name}"
        redirect_back_or_default admin_root_path
      else # No email correspondence found, user rejected
        flash[:alert] = "User not found"
        redirect_to :admin_login
      end
    end
  end

  def failure
    flash[:alert] = "You haven't authorized your Google account."
    redirect_to root_url
  end

  # omniauth needs this method to handle the authentication process
  def blank
    render text: "Not Found", status: 404
  end
end
