# frozen_string_literal: true

module Onboarding
  # Shared behavior for every onboarding step controller.
  class BaseController < ApplicationController
    allow_unauthenticated_access

    before_action :redirect_if_complete
    before_action :ensure_step_reachable!
    before_action :sync_onboarding_step!, only: :show
    skip_before_action :check_onboarding_state

    layout 'onboardings'

    private

    def redirect_if_complete
      redirect_to root_path if Current.setting.onboarding_complete?
    end

    def ensure_step_reachable!
      return if step_reachable?(self.class::STEP)

      redirect_to Steps.path_for(Current.setting.onboarding_step)
    end

    def step_reachable?(step)
      Setting::ONBOARDING_STEPS.index(step) <= Current.setting.furthest_index
    end

    def sync_onboarding_step!
      Current.setting.retreat!(from: self.class::STEP)
    end

    def advance!
      Current.setting.advance!(from: self.class::STEP)
    end

    def advance_and_redirect!
      advance!
      redirect_to Steps.path_for(Current.setting.onboarding_step)
    end
  end
end
