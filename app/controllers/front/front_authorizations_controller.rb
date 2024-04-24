class Front::FrontAuthorizationsController < Front::BaseController
  def create
    omniauth_data = request.env["omniauth.auth"] # Google response with user data
    omniauth_params = request.env["omniauth.params"]
    authorization = FrontAuthorization.find_from_omniauth_data(omniauth_data) # Look for a previous authorization

    if authorization # User was already authenticated with Google, log the user in
      flash[:notice] = "Welcome back #{authorization.front_user.name}"
      FrontSession.create(authorization.front_user, true)
      redirect_back_or_default front_root_path
    else # First authentication with google, check for email correspondence
      front_user = FrontUser.find_by_email omniauth_data[:info][:email]

      if front_user # FrontUser with Google email found, create authentication record and log the user in
        front_user.authorizations.create({ provider: omniauth_data[:provider], uid: omniauth_data[:uid] })
        FrontSession.create(front_user, true)
        flash[:notice] = "Welcome back #{front_user.name}"
        redirect_back_or_default front_root_path
      else
        if omniauth_params && omniauth_params["sign_up"] # It is a Sign up
          front_user = FrontAuthorization.create_user_from_omniauth_data(omniauth_data)
          front_user.authorizations.create({ provider: omniauth_data[:provider], uid: omniauth_data[:uid] })
          FrontSession.create(front_user, true)
          flash[:notice] = "Welcome #{front_user.name}, you have been registered"
          redirect_to front_root_path
        else
          flash[:alert] = "User not found"
          redirect_to :front_login
        end
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
