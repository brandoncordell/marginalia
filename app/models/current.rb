# frozen_string_literal: true

# Per-request global state: the active session, instance settings, and — by
# delegation — the signed-in user.
class Current < ActiveSupport::CurrentAttributes
  attribute :session, :setting

  delegate :user, to: :session, allow_nil: true

  def self.setting
    super || self.setting = Setting.instance
  end
end
