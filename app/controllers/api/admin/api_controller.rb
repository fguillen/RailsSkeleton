class Api::Admin::ApiController < Api::ApiController
  protect_from_forgery with: :null_session

  def supported_tokens
    Array.wrap(APP_CONFIG[:api]['admin_token'])
  end
end
