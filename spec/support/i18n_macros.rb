RSpec.configure do |config|
  config.before(:each) do
    page.driver.header('Accept-Language', 'de')
  end
end

module I18nMacros
  def t(*args)
    I18n.translate!(*args)
  end
end
