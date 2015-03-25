source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'bcrypt-ruby'
gem 'jquery-rails'
gem 'pg'
gem 'bootstrap_form'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', require: false
  gem 'fabrication', '~> 2.12.1'
  gem 'faker', '~> 1.4.3'
  gem 'capybara'
  gem 'launchy'
end

group :production do
  gem 'rails_12factor'
end