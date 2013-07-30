source 'https://rubygems.org'

ruby '2.0.0'
gem 'rails', '4.0.0'
gem 'redis-rails', github: 'jodosha/redis-store'
gem 'bcrypt-ruby'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails-cdn'
gem 'clockwork'
gem 'sidekiq'
gem 'browser'
gem 'signet', require: 'signet/oauth_2/client'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 2.1.1'
gem 'zurb-foundation', '~> 4.3.1'
gem 'magnific-popup-rails', '>= 0.8.9'
gem 'cache_digests'
gem 'unicorn'
gem 'faye'
gem 'hiredis'
gem 'modernizr-rails'
gem 'active_model_serializers'
gem 'gibberish'
gem 'spinjs-rails'

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
  gem 'lograge'
  gem 'clockworkd'
  gem 'daemons'
end
