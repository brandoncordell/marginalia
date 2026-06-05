# frozen_string_literal: true

# Settings model for the app.
#
# Setting is a singleton model, so there is only one row in the database.
#
# @example
#   Setting.instance.onboarding_step = 'library'
#   Setting.instance.save!
class Setting < ApplicationRecord
  ONBOARDING_STEPS = %w[welcome account library metadata import done].freeze

  before_create :set_os_information

  def self.instance = first_or_create!

  # Whether the onboarding wizard has been completed.
  #
  # @return [Boolean]
  def onboarding_complete?
    onboarded_at?
  end

  # Advance the onboarding wizard to the given step.
  #
  # @param step [String] The step to advance to.
  # @return [void]
  def advance_to(step)
    return unless ONBOARDING_STEPS.index(step) > furthest_index

    update!(onboarding_step: step)
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
