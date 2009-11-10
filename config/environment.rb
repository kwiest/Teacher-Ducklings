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
  
  # Amazon Web Services
  config.gem "right_aws", :version => "1.10.0"
  
  # MIME Types
  config.gem "mime-types", :lib => "mime/types"
  
  # Flash Session Key Middleware
  config.middleware.use "FlashSessionCookieMiddleware"
  
  # RVideo + FLVTool2
  config.gem "rvideo"
  config.gem "flvtool2"
  

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'
end