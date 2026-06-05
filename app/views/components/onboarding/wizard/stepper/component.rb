# frozen_string_literal: true

# Onboarding Wizard Stepper component
module Onboarding
  module Wizard
    module Stepper
      # Stepper component
      class Component < ApplicationViewComponent
        renders_many :steps, Step::Component
      end
    end
  end
end
