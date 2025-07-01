source "https://rubygems.org"

ruby "3.4.4"

# Rails core
gem "rails", "~> 7.1.5", ">= 7.1.5.1"
gem "bootsnap", require: false

# Database
gem "pg", "~> 1.1"

# Web server
gem "puma", ">= 5.0"

# Asset pipeline and frontend
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "chartkick"

# API and JSON
gem "jbuilder"

# Authentication and security
gem "bcrypt"

# Pagination and utilities
gem "kaminari"
gem "csv"
gem "doorkeeper"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]

group :development, :test do
  # Testing framework
  gem "rspec-rails"
  gem "rspec"
  gem "factory_bot_rails"
  gem "shoulda-matchers"
  gem "faker"
  gem "capybara"
  gem "selenium-webdriver"
  gem "rails-controller-testing"

  # Debugging
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  # Console and debugging
  gem "web-console"

  # Performance profiling (commented out)
  # gem "rack-mini-profiler"

  # Speed up commands (commented out)
  # gem "spring"
end

# Redis gems (commented out)
# gem "redis", ">= 4.0.1"
# gem "kredis"

# Image processing (commented out)
# gem "image_processing", "~> 1.2"
