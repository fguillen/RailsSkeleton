source "https://rubygems.org"
ruby "~> 3.1.1"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Please: keep the gem declarations sorted.
#   This will make future mergings MUCH easier. <3
gem "active_storage_validations"
gem "acts-as-taggable-on"
gem "authlogic"
gem "aws-sdk-s3", require: false
gem "bluecloth"
gem "data_migrate"
gem "dotenv-rails"
gem "faker"
gem "fast_blank"
gem "i18n-tasks"
gem "image_processing"
gem "jbuilder"
gem "jquery-rails"
gem "kaminari"
gem "log_book"
gem "mysql2"
gem "oj"
gem "omniauth-google-oauth2"
gem "omniauth"
gem "puma"
gem "rails", "~> 7.0"
gem "redcarpet"
gem "rexml"
gem "rollbar"
gem "ruby_regex", git: "https://github.com/fguillen/ruby_regex.git"
gem "sass-rails"
gem "scrypt"
gem "sendgrid-actionmailer"
gem "strip_attributes"
gem "style_palette"
gem "uglifier"
gem "uuid"
gem "virtus-relations"
gem "virtus"


group :test do
  gem "database_cleaner"
  gem "factory_bot"
  gem "minitest"
  gem "mocha"
  gem "rails-controller-testing"
  gem "simplecov", require: false
end

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capybara"
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
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
  gem "web-console"
end
