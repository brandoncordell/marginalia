# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# A development sign-in account. The Rails 8 auth stack ships no registration flow,
# so this provides a user to log in with. Override via SEED_USER_EMAIL / SEED_USER_PASSWORD.
if Rails.env.development?
  email = ENV.fetch('SEED_USER_EMAIL', 'dev@example.com')
  password = ENV.fetch('SEED_USER_PASSWORD', 'password')

  User.find_or_create_by!(email_address: email) do |user|
    user.first_name = ENV.fetch('SEED_USER_FIRST_NAME', 'Dev')
    user.last_name = ENV.fetch('SEED_USER_LAST_NAME', 'User')
    user.password = password
  end
end
