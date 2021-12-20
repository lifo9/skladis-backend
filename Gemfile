source 'https://rubygems.org'

ruby File.read('.ruby-version').strip


#-------------------------------------------------------------------------------
# Core infrastructure
#-------------------------------------------------------------------------------

gem 'rails', '~> 7.0'

# the Ruby interface to the PostgreSQL RDBMS
gem 'pg'

# A Ruby client that tries to match Redis' API one-to-one, while still providing an idiomatic interface.
gem 'redis'

# optimize and cache expensive computations
gem 'bootsnap'

# Puma is a simple, fast, multi-threaded, and highly parallel HTTP 1.1 server for Ruby/Rack applications.
gem 'puma'

#-------------------------------------------------------------------------------
# Rails configuration, middleware, extensions
#-------------------------------------------------------------------------------

# XSS/CSRF safe JWT auth designed for SPA
gem 'jwt_sessions'

# An easy way to keep your users' passwords secure.
gem 'bcrypt'

# allows web applications to make cross domain AJAX calls without using workarounds such as JSONP
gem 'rack-cors'

# authorization system
gem 'pundit'

#-------------------------------------------------------------------------------
# Assets
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# 3rd-party & APIs
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Services and utilities
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Development & Test
#-------------------------------------------------------------------------------

group :development, :test do
  # a testing framework
  gem 'rspec'
  gem 'rspec-rails'

  # Factories - libraries for setting up Ruby objects as test data
  gem 'factory_bot_rails'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end


group :development do
  # listens to file modifications and notifies you about the changes.
  gem 'listen'

  # application preloader
  gem 'spring'
  gem 'spring-watcher-listen'

  # preview emails
  gem "letter_opener", group: :development
end
