source 'https://rubygems.org'

ruby '2.0.0'
gem 'rails', '4.0.0.rc1'
gem 'rack-cache', require: 'rack/cache'
gem 'bcrypt-ruby'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'clockwork'
gem 'redis'
gem 'sidekiq'
gem 'puma'
gem 'agent_orange'
gem 'dropbox-sdk'
gem 'sass-rails', '~> 4.0.0.rc1'
gem 'uglifier', '>= 2.1.1'
gem 'zurb-foundation', '~> 4.0.0'
gem 'magnific-popup-rails'

group :test, :development do
  gem 'sqlite3'
  gem 'foreman'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara', '>= 2.1.0'
  gem 'capybara-webkit', '>= 1.0.0'
  gem 'database_cleaner'
end

group :production do
  gem 'pg'
  gem 'newrelic_rpm'
end
