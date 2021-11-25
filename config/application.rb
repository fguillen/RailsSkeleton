require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsSkeleton
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults "6.0"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += ["#{Rails.root}/lib"]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en]
    I18n.enforce_available_locales = true

    # log_book
    config.after_initialize do
      require "log_book/event"
    end
  end
end
