# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Netflix::Application.config.secret_key_base = '8675ab5d75d4dd0c83ad329154acc9cca82ad4590b3a8c4d33cbf708c0839606ec67546c0dab7489f186cc385f94bfd3abdd58800fe23f7400e95a84c33ef6cc'
