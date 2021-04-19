source "https://rubygems.org"
ruby "2.6.3"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Please: keep the gem declarations sorted.
#   This will make future mergings MUCH easier. <3
gem "active_storage_validations"
gem "authlogic", "6.0.0"
gem "aws-sdk-s3", require: false
gem "bluecloth"
gem "bootsnap", require: false
gem "data_migrate"
gem "dotenv-rails"
gem "fast_blank"
gem "i18n-tasks", "~> 0.9.31"
gem "image_processing"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "mini_graphite", :git => "https://github.com/ScrapStatsResearch/MiniGraphite.git"
gem "mysql2", ">= 0.3.18", "< 0.6.0"
gem "newrelic_rpm"
gem "oj"
gem "omniauth"
gem "omniauth-google-oauth2", "~> 0.4.1"
gem "puma", "~> 3.11"
gem "rails", "~> 6.0.2.2"
gem "redcarpet"
gem "rollbar"
gem "ruby_regex", :git => "https://github.com/fguillen/ruby_regex.git"
gem "sass-rails", "~> 6.0"
gem "scrypt", "~> 3.0"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"
gem "uuid"
gem "virtus"
gem "virtus-relations"

group :test do
  gem "database_cleaner"
  gem "factory_bot"
  gem "minitest"
  gem "mocha"
  gem "rails-controller-testing"
  gem "simplecov", :require => false
end

group :development, :test do
  gem "faker"
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capybara", "~> 2.13"
  gem "selenium-webdriver"
  gem "timecop"
  gem "webdrivers"
end

group :development do
  gem "awesome_print"
  gem "brakeman"
  gem "bundle-audit"
  gem "guard"
  gem "guard-minitest"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end
