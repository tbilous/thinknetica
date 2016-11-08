# require 'selenium-webdriver'
require 'capybara/poltergeist'
Dir[Rails.root.join('spec/macros/**/*.rb')].each { |f| require f }
RSpec.configure do |config|

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
        app,
        timeout: 90, js_errors: true,
        phantomjs_logger: Logger.new(STDOUT),
        window_size: [1020, 740]
    )
  end

  Capybara.javascript_driver = :poltergeist

  # Capybara.javascript_driver = :webkit
  Capybara.page.driver.header('HTTP_ACCEPT_LANGUAGE', 'de')
  Capybara.ignore_hidden_elements = false
  config.include AbstractController::Translation
  config.include I18nMacros
end
