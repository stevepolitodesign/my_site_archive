ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'vcr'


VCR.configure do |config|
  config.cassette_library_dir = "test/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.allow_http_connections_when_no_cassette = true
  config.filter_sensitive_data('<BROWSERLESS_PRIVATE_KEY>') { Rails.application.credentials.dig(:browserless, :private_key) }
end


class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include Devise::Test::IntegrationHelpers

  def assert_user_not_authorized
    assert_text "You are not authorized to perform this action."
  end

  def assert_user_authenticated
    assert_text "You need to sign in or sign up before continuing."
  end
end