# frozen_string_literal: true

module Onboarding
  # GET /onboarding — sends visitors to their current (or furthest) step.
  class EntriesController < ApplicationController
    allow_unauthenticated_access
    skip_before_action :check_onboarding_state

    def show
      redirect_to root_path if Current.setting.onboarding_complete?

      redirect_to Steps.path_for(Current.setting.onboarding_step)
    end
  end
end
