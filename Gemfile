source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# for Heroku deployment - as described in Ap. A of ELLS book
group :development, :test do
  gem 'simplecov', :require => false
  gem 'sqlite3'
  gem 'debugger'
  #gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'capybara'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'omniauth-twitter', '~> 1.0'
  gem 'omniauth-facebook', "~> 1.0"
end
group :test do
  gem 'cucumber-rails', :require => false
  gem 'ZenTest'
  gem 'cucumber-rails-training-wheels'
end
group :production do
#  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer'              
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'ruby-tmdb'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
gem 'haml'
