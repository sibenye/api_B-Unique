# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_api_B-Unique_session',
  :secret      => '7c94b46ab518fccd4ed7ee885b0fdf84c7c4046a4db046d44c3ae707d4ce7ac5643d53fca1140048c3ded160204916b7b8dc2f1d50421518970f244bb1991c63'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
