# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~> 8.1.3'

gem 'bootsnap', require: false
gem 'dry-initializer', '~> 3.2'
gem 'image_processing', '~> 1.2'
gem 'importmap-rails'
gem 'jbuilder'
gem 'kamal', require: false
gem 'pg', '~> 1.1'
gem 'propshaft'
gem 'puma', '>= 5.0'
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'thruster', require: false
gem 'turbo-rails'
gem 'view_component', '~> 4.11'
gem 'view_component-contrib', '~> 0.2.5'
# gem "bcrypt", "~> 3.1.7"

group :development do
  gem 'web-console'
end

group :development, :test do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
