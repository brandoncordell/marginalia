# frozen_string_literal: true

# Per-request global state: the active session and, by delegation, its user.
class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true
end
