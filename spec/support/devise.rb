RSpec.configure do |config|
  # Rspec
  config.include Devise::Test::ControllerHelpers, type: :controller

  # Capybara
  config.include Warden::Test::Helpers

  config.after :each do
    Warden.test_reset!
  end
end
