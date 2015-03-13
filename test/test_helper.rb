ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'capybara/rails'

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new, ENV, Minitest.backtrace_filter

module WarehouseHelpers
  def expected_roles
    %w{ staff principal qty_control warehouse finance admin }
  end
  
  def expected_order_states
    %w{ draft reviewing submitted fulfilled archived cancelled }
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  include Warden::Test::Helpers
  
  def with_user(user)
    login_as(user, scope: :user)
    yield if block_given?
    logout(user)
  end
end

ActiveRecord::FixtureSet.context_class.send :include, WarehouseHelpers