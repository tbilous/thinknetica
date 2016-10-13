require 'rubygems'
require 'spork'
require 'database_cleaner'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
# uncomment the following line to use spork with the debugger
# require 'spork/ext/ruby-debug'

Spork.prefork do
  RSpec.configure do |config|
    config.include AbstractController::Translation

    config.include Rails.application.routes.url_helpers

    config.expect_with :rspec do |expectations|
      expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    end

    config.mock_with :rspec do |mocks|
      mocks.verify_partial_doubles = true
    end

    config.include Capybara::DSL
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
end
