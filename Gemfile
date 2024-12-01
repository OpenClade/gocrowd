source "https://rubygems.org"

ruby "3.0.2"

# Rails and related gems
gem "rails", "~> 7.1.5"
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "state_machines"
gem "state_machines-activerecord"

# Web server
gem "puma", ">= 5.0"

# Database
gem "pg", "~> 1.5"

# Authentication and Authorization
gem "bcrypt", "~> 3.1.12"
gem "jwt", "~> 2.5"

# CORS
gem "rack-cors"

# Serialization
gem "active_model_serializers", "~> 0.10.12"

# Time zone data for Windows
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]

# Performance
gem "bootsnap", require: false

# Admin interface
gem "trestle", "~> 0.10.1"
gem "trestle-auth", "~> 0.5.0"

# API documentation
gem "rswag", "~> 2.16"

# Development and Test groups
group :development, :test do
  gem "factory_bot_rails"
  gem "rspec-rails", "6.1.0" 
  gem "rails-controller-testing" 
  gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ]
end

group :development do
  gem "web-console"
  # Uncomment the following lines if needed
  # gem "rack-mini-profiler"
  # gem "spring"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
