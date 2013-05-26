source 'https://rubygems.org'

ruby '2.0.0'
gem 'rails', '3.2.13'
gem 'rack-cache', require: 'rack/cache'
gem 'bcrypt-ruby'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'coffee-rails', '~> 3.2.1'
gem 'jquery-rails'
gem 'clockwork'
gem 'redis'
gem 'sidekiq'
gem 'puma'
gem 'agent_orange'
gem 'dropbox-sdk'

group :test, :development do
  gem 'sqlite3'
  gem 'foreman'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara', '>= 2.1.0'
  gem 'spork-rails'
  gem 'rb-inotify'
  gem 'capybara-webkit', '>= 1.0.0'
  gem 'database_cleaner'
end

group :production do
  gem 'pg'
  gem 'newrelic_rpm'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
  gem 'zurb-foundation', '~> 4.0.0'
  gem 'magnific-popup-rails'
end

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
