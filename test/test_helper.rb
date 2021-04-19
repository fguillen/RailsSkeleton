if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.command_name "MiniTest #{Time.now}"
  SimpleCov.start "rails"
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "mocha/setup"
require_relative "factories"
require 'authlogic/test_case'


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  FIXTURES_PATH = "#{File.dirname(__FILE__)}/fixtures"

  def fixture(fixture_path)
    File.expand_path "#{FIXTURES_PATH}/#{fixture_path}"
  end

  def read_fixture(fixture_path)
    File.read(fixture(fixture_path))
  end

  def write_fixture(fixture_path, content)
    puts "ATENTION: fixture: '#{fixture_path}' been written"
    File.open(fixture(fixture_path), "w") { |f| f.write content }
  end

  def setup_admin_user
    @admin_user = FactoryBot.create(:admin_user)
    @controller.stubs(:current_admin_user).returns(@admin_user)
  end

  def setup_appreciable_user
    @appreciable_user = FactoryBot.create(:appreciable_user)
    @controller.stubs(:current_appreciable_user).returns(@appreciable_user)
  end

  def assert_ids(array_1, array_2, message = nil)
    assert_equal(array_1.ids, array_2.ids)
  end

  def assert_primary_keys(array_1, array_2, message = nil)
    array_1_keys = array_1.map { |e| e.send(e.class.primary_key) }
    array_2_keys = array_2.map { |e| e.send(e.class.primary_key) }
    assert_equal(array_1_keys, array_2_keys)
  end

  # Add more helper methods to be used by all tests here...
end
