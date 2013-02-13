source 'https://rubygems.org'
ruby "1.9.3"
require 'rubygems'

gem 'rails', '3.1.10'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'apn_on_rails', :git => 'https://github.com/natescherer/apn_on_rails.git', :branch => 'rails3'
gem 'devise'
gem 'cancan'
gem 'omniauth-facebook'
gem 'pusher'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'

group :development do
	gem 'sqlite3'
end
group :production do
	gem 'pg'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
	gem 'sqlite3'
end
