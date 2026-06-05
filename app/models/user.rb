# frozen_string_literal: true

# An account that can authenticate and hold sessions.
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :first_name, :last_name, presence: true
  validates :admin, uniqueness: true, if: :admin?

  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt&.last(10)
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def initials
    [first_name, last_name].filter_map { |name| name&.strip&.first }.join.upcase
  end
end
