RSpec.configure do |config|
  config.before(:each) do
    page.driver.header('Accept-Language', 'de')
  end
  config.include AbstractController::Translation
  config.include I18nMacros
end
