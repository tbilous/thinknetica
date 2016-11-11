Dir[Rails.root.join('spec/macros/**/*.rb')].each { |f| require f }
RSpec.configure do |config|
  Capybara.page.driver.header('HTTP_ACCEPT_LANGUAGE', 'de')
  Capybara.ignore_hidden_elements = false
  config.include AbstractController::Translation
  config.include I18nMacros
end
