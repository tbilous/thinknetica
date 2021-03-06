source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails', '5.0.0.1'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0', '>= 5.0.6'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'rubygems-bundler'
gem 'puma'

# Frontend framework
gem 'materialize-sass'
gem 'material_icons'

# slim
gem 'slim'
gem 'slim-rails'

# Authorization
gem 'devise'
gem 'devise-i18n'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-github'
gem 'cancancan', '~> 1.10'

# i18n
# gem 'russian'
gem 'rails-i18n'

# attachment files
gem 'carrierwave'
gem 'cocoon'
gem 'remotipart'

# js
gem 'skim'
gem 'gon'

# API
gem 'doorkeeper'

gem 'sprockets', '3.6.3'

# json response
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'

gem 'responders'

# jobs
gem 'sidekiq'

# sphinx
gem 'mysql2',          '~> 0.3.18', :platform => :ruby
gem 'thinking-sphinx', '~> 3.3.0'

# deploy
gem 'therubyracer'
gem 'whenever'
gem 'unicorn', '5.2.0'

group :development, :test do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-commands-cucumber'
  gem 'byebug'
  gem 'rspec-rails'
  gem 'childprocess'
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'timecop'
  gem 'faker'
  gem 'letter_opener'
end

group :test do
  gem 'poltergeist'
  gem 'selenium-webdriver', '2.53.4'
  gem 'capybara'
  gem 'capybara-email'
  gem 'capybara-webkit', '1.11.1'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'json_spec'
  gem 'fuubar'
  gem 'rspec-page-regression', github: 'teachbase/rspec-page-regression', branch: 'use-imatcher'
  gem 'rack_session_access'
end

group :development do
  gem 'spring-commands-rubocop'
  gem 'web-console', '~> 3.0'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-secrets-yml', '~> 1.0.0', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', '0.2.1', require: false
end
