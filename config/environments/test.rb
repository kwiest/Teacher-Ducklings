TeacherDucklings::Application.configure do
  ENV['S3_KEY'] = 'AKIAJJS76LHBMMUAS25A'
  ENV['S3_SECRET'] = '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'
  ENV['S3_BUCKET'] = 'teacherducklings-test'
  ENV['ZENCODER_API_KEY'] = '430c2da3719c97f45098f52d11601eca'
  ENV['POSTMARK_API_KEY'] = '23c53650-4523-44d6-b24f-6e6f3dd79898'
  ENV['TOKBOX_API_KEY'] = '11727762'
  ENV['TOKBOX_API_SECRET'] = '1800b0dda3f984e52e8e7f765a1fdd3b8a7df13b'

  # Settings specified here will take precedence over those in config/environment.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.action_controller.consider_all_requests_local = true
  config.action_controller.perform_caching             = false
  # config.action_view.cache_template_loading            = true

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql
  
  # Log deprecation warnings to STDERR
  config.active_support.deprecation = :stderr
end
