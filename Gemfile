source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.13'
gem 'rack-cache', require: 'rack/cache'
gem 'bcrypt-ruby'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'coffee-rails', '~> 3.2.1'
gem 'clockwork'
gem 'redis'
gem 'sidekiq'
gem 'puma'

group :test, :development do
  platforms :jruby do
    gem 'jdbc-sqlite3'
    gem 'activerecord-jdbc-adapter'
  end

  platforms :ruby, :rbx do
    gem 'sqlite3'
  end
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'spork-rails'
  gem 'libnotify'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
end

group :production do
  platform :jruby do
    gem 'activerecord-jdbcpostgresql-adapter'
  end

  platform :ruby do
    gem 'pg'
  end

  gem 'newrelic_rpm'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
  gem 'zurb-foundation', '~> 4.0.0'
end

gem 'jquery-rails'


# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
