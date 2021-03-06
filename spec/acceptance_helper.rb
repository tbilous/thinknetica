require 'rails_helper'
require 'rspec/page-regression'
require 'capybara/poltergeist'
require 'rack_session_access/capybara'
require 'puma'
require 'capybara/email/rspec'
require 'i18n'
# require 'selenium-webdriver'

RSpec.configure do |config|
  include ActionView::RecordIdentifier
  config.include AcceptanceHelper, type: :feature
  config.include FeatureMacros, type: :feature
  OmniAuth.config.test_mode = true
  config.before(:each, type: :feature) do
    default_url_options[:locale] = I18n.default_locale
  end

  # Capybara.server_host = '0.0.0.0'
  # Capybara.server_port = 3001 + ENV['TEST_ENV_NUMBER'].to_i
  # Capybara.default_max_wait_time = 2
  # Capybara.save_path = './tmp/capybara_output'
  # Capybara.always_include_port = true # for correct app_host

  Capybara.register_driver :poltergeist do |app|
    # noinspection RubyArgCount
    Capybara::Poltergeist::Driver.new(
      app,
      timeout: 90,
      js_errors: true,
      phantomjs_logger: Logger.new(STDOUT),
      window_size: [1920, 6000]
    )
  end

  Capybara.javascript_driver = :poltergeist
  # Capybara.javascript_driver = :selenium

  Capybara.server = :puma

  RSpec::PageRegression.configure do |c|
    c.threshold = 0.01
  end

  config.use_transactional_fixtures = false

  config.before(:suite) { DatabaseCleaner.clean_with :truncation }

  config.before(:each) { DatabaseCleaner.strategy = :transaction }

  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }

  # config.before(:each, type: :feature) { Capybara.app_host = "http://dev.#{Capybara.server_host}.xip.io/en" }

  config.before(:each) { DatabaseCleaner.start }

  config.after(:each) { Timecop.return }

  config.append_after(:each) do
    Capybara.reset_sessions!
    DatabaseCleaner.clean
  end
end
