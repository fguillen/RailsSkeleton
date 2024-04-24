# rubocop:disable Naming/VariableNumber
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, APP_CONFIG["google_auth"]["client_id"], APP_CONFIG["google_auth"]["client_secret"], scope: "email, profile"
end
# OmniAuth.config.allowed_request_methods = %i[get]
OmniAuth.config.logger = Rails.logger
# rubocop:enable Naming/VariableNumber
