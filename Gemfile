source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'rack-cache', :require => 'rack/cache'
gem 'bcrypt-ruby'
gem 'recaptcha', :require => 'recaptcha/rails'
gem 'coffee-rails', '~> 3.2.1'


# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
group :test, :development do
gem 'sqlite3'
gem 'minitest'
end

group :production do
  ruby '1.9.3', :engine => 'jruby', :engine_version => '1.7.3'
  gem 'pg'
  gem 'puma'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
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
