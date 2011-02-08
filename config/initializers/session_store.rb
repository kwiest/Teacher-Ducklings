# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_teacherducklings_session',
  :secret      => 'afaf09c6809344d6a0f814d76e8d8559b659210f46e3e8e3956dc1297af95b0491c5f2ab518da267d0c7bc59a46b9a62333edd6ba7eb0de0c69b8cc04b95a277'
}

ActionController::Dispatcher.middleware.insert_before(
  ActionController::Session::CookieStore,
  FlashSessionCookieMiddleware,
  ActionController::Base.session_options[:key]
)

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
