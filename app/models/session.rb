# frozen_string_literal: true

# A signed-in user's session, persisted server-side and referenced by a signed cookie.
class Session < ApplicationRecord
  belongs_to :user
end
