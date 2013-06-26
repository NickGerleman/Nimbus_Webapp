source 'https://rubygems.org'

ruby '1.9.0', :engine => "rbx", :engine_version => "2.0.0.rc1"
gem 'rails', '4.0.0'
gem 'rack-cache', require: 'rack/cache'
gem 'bcrypt-ruby'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'clockwork'
gem 'sidekiq'
gem 'browser'
gem 'signet', require: 'signet/oauth_1/client'
gem 'signet', require: 'signet/oauth_2/client'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 2.1.1'
gem 'zurb-foundation', '~> 4.2.2'
gem 'magnific-popup-rails', '>= 0.8.9'
gem 'puma'

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
  gem 'newrelic_rpm'
  gem 'pg'
  gem 'rails_12factor'
end
