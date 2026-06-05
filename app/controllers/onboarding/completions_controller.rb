# frozen_string_literal: true

module Onboarding
  # Completion step controller for the onboarding wizard.
  class CompletionsController < BaseController
    STEP = 'done'

    def show; end

    def create
      Current.setting.update!(onboarded_at: Time.current)
      redirect_to root_path
    end
  end
end
