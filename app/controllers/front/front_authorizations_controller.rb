class Front::FrontAuthorizationsController < Front::BaseController
  before_action :require_front_user, only: [:destroy]

  def create
    omniauth_data = request.env['omniauth.auth'] # Google response with user data
    authorization = FrontAuthorization.find_from_omniauth_data(omniauth_data) # Look for a previous authorization

    if authorization # User was already autenticated with Google, log the user in
      flash[:notice] = "Welcome back #{authorization.front_user.name}"
      FrontSession.create(authorization.front_user, true)
      redirect_back_or_default front_root_path
    else # First authentication with google, check for email correspondence
      front_user = FrontUser.find_by_email omniauth_data[:info][:email]

      if front_user # FrontUser with Google email found, create authentication record and log the user in
        front_user.authorizations.create({ provider: omniauth_data['provider'], uid: omniauth_data['uid'] })
        FrontSession.create(front_user, true)
        flash[:notice] = "Welcome #{front_user.name}"
        redirect_back_or_default front_root_path
      else # No email correspondence found, user rejected
        flash[:alert] = "You are not authorized to access this resource"
        redirect_to :front_login
      end
    end
  end
end
