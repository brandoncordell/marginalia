# frozen_string_literal: true

# Delivers the password reset email containing a tokenized link.
class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: 'Reset your password', to: user.email_address
  end
end
