# frozen_string_literal: true

# Settings model for the app.
#
# Setting is a singleton model, so there is only one row in the database.
#
# @example
#   Current.setting.advance! # moves from the current step to the next
class Setting < ApplicationRecord
  # metadata step disabled until provider settings are added to the schema
  ONBOARDING_STEPS = %w[welcome account library import done].freeze
  # METADATA_PROVIDERS = %w[open_library google_books manual].freeze

  before_create :set_os_information

  def self.instance = first_or_create!

  # Whether the onboarding wizard has been completed.
  #
  # @return [Boolean]
  def onboarding_complete?
    onboarded_at?
  end

  # Advance the onboarding wizard to the step after +from+.
  #
  # Pass the controller's current step so going back and continuing again does
  # not skip ahead from the furthest step already stored in the database.
  #
  # @param from [String] the step being completed
  # @return [String, nil] the new step, or +nil+ if already at the final step
  def advance!(from: onboarding_step)
    next_step = Onboarding::Steps.next(from)
    return unless next_step

    update!(onboarding_step: next_step)
    next_step
  end

  # Sync the stored step when the user revisits an earlier step (e.g. via Back).
  #
  # @param from [String] the step being viewed
  def retreat!(from: onboarding_step)
    step_index = ONBOARDING_STEPS.index(from.to_s)
    return unless step_index && step_index < furthest_index

    update!(onboarding_step: from)
  end

  # The index of the furthest onboarding step reached.
  #
  # @return [Integer]
  def furthest_index
    ONBOARDING_STEPS.index(onboarding_step) || 0
  end

  private

  def containerized?
    File.exist?('/.dockerenv')
  end

  def host_os
    [`uname`.strip.downcase, `uname -m`.strip].join('/').to_s
  end

  def set_os_information
    self.operating_system = host_os
    self.docker = containerized?
  end
end
