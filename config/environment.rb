# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  
  ENV['RAILS_ENV'] = 'production'
  RAILS_ENV = ENV["RAILS_ENV"]
  
  # Authlogic Gem
  config.gem "authlogic"
  
  # Paperclip Gem
  config.gem "paperclip"
  
  # Calendar select
  config.gem "calendar_date_select"
  
  # RVideo
  config.gem "rvideo"
  
  # Flash Session Key Middleware
  config.middleware.use "FlashSessionCookieMiddleware"
  
  config.time_zone = 'UTC'
end
