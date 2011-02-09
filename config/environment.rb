# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.10' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Gems
  config.gem "authlogic", :version => '2.1.6'
  config.gem "paperclip", :version => '2.3.5'
  config.gem "rvideo", :version => '0.9.3'
  config.gem "delayed_job", :version => '1.8.5'
  config.gem "simple_form", :version => '1.0.2'
  
  # Flash Session Key Middleware
  config.middleware.use "FlashSessionCookieMiddleware"
  
  config.time_zone = 'Pacific Time (US & Canada)'
end
