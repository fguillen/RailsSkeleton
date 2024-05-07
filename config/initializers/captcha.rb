# We are using: Cloudflare Turnstile
Turnstile.configure do |config|
  config.site_key = APP_CONFIG["captcha"]["site_key"]
  config.secret_key = APP_CONFIG["captcha"]["secret_key"]
  config.on_failure = ->(verification) { Rails.logger.error("Captcha failure: #{verification.result}") }
end
