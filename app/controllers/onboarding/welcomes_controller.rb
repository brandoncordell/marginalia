# frozen_string_literal: true

module Onboarding
  # Welcome step controller for the onboarding wizard.
  class WelcomesController < BaseController
    STEP = 'welcome'

    def show; end

    def update
      advance_and_redirect!
    end
  end
end
