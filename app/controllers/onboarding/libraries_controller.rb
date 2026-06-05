# frozen_string_literal: true

module Onboarding
  # Library step controller for the onboarding wizard.
  class LibrariesController < BaseController
    STEP = 'library'

    def show; end

    def update
      advance_and_redirect!
    end
  end
end
