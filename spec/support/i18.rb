RSpec.configure do |config|
  # config.before(:each) do
  #   page.driver.header('Accept-Language', 'de')
  # end
  Capybara.page.driver.header('HTTP_ACCEPT_LANGUAGE', 'de')
  config.include AbstractController::Translation
  config.include I18nMacros
end
