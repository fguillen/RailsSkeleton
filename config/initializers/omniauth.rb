# rubocop:disable Naming/VariableNumber
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, APP_CONFIG["google_auth"]["client_id"], APP_CONFIG["google_auth"]["client_secret"]
end
# rubocop:enable Naming/VariableNumber
