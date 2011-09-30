# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.14' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Gems
  config.gem 'authlogic', :version => '2.1.6'
  config.gem 'aws', :version => '2.5.6'
  config.gem 'aws-s3', :version => '0.6.2'
  config.gem 'paperclip', :version => '2.3.5'
  config.gem 'simple_form', :version => '1.0.2'
  config.gem 'zencoder', :version => '2.3.1'
  config.gem 'state_machine', :version => '1.0.2'

  config.gem 'postmark', :version => '0.9.8'
  config.gem 'postmark-rails', :version => '0.4.1'
  require 'postmark-rails'
  config.action_mailer.delivery_method = :postmark
  config.action_mailer.postmark_api_key = ENV['POSTMARK_API_KEY']

  config.time_zone = 'Pacific Time (US & Canada)'
end
