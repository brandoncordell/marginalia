# frozen_string_literal: true

module Onboarding
  # Maps onboarding step names to their RESTful routes.
  module Steps
    def self.path_for(step)
      routes = Rails.application.routes.url_helpers

      case step.to_s
      when 'welcome' then routes.onboarding_welcome_path
      when 'account' then routes.onboarding_account_path
      when 'library' then routes.onboarding_library_path
      # when 'metadata' then routes.onboarding_metadata_path
      when 'import' then routes.onboarding_import_path
      when 'done' then routes.onboarding_completion_path
      else routes.onboarding_root_path
      end
    end

    def self.next(step)
      index = Setting::ONBOARDING_STEPS.index(step.to_s)
      return unless index

      Setting::ONBOARDING_STEPS[index + 1]
    end
  end
end
