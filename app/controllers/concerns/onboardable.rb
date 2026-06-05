# frozen_string_literal: true

# Cookie-based session authentication: gates every controller by default and
# exposes `allow_unauthenticated_access` to opt specific actions out.
module Onboardable
  extend ActiveSupport::Concern

  included do
    prepend_before_action :check_onboarding_state
  end

  private

  def check_onboarding_state
    redirect_to onboarding_root_path unless Current.setting.onboarding_complete?
  end
end
