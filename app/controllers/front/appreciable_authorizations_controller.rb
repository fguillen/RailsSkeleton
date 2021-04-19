class Front::AppreciableAuthorizationsController < Front::BaseController
  before_action :require_appreciable_user, :only => [:destroy]

  def create
    omniauth_data = request.env['omniauth.auth'] # Google response with user data
    authorization = AppreciableAuthorization.find_from_omniauth_data(omniauth_data) # Look for a previous authorization

    if authorization # User was already autenticated with Google, log the user in
      flash[:notice] = "Welcome back #{authorization.appreciable_user.name}"
      AppreciableSession.create(authorization.appreciable_user, true)
      redirect_back_or_default front_root_path
    else # First authentication with google, check for email correspondence
      appreciable_user = AppreciableUser.find_by_email omniauth_data[:info][:email]

      if appreciable_user # AppreciableUser with Google email found, create authentication record and log the user in
        appreciable_user.authorizations.create({ :provider => omniauth_data['provider'], :uid => omniauth_data['uid'] })
        AppreciableSession.create(appreciable_user, true)
        flash[:notice] = "Welcome #{appreciable_user.name}"
        redirect_back_or_default front_root_path
      else # No email correspondence found, user rejected
        flash[:alert] = "You are not authorized to access this resource"
        redirect_to :front_login
      end
    end
  end
end
