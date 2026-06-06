# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include Onboardable

  allow_browser versions: :modern
  default_form_builder TailwindFormBuilder
  stale_when_importmap_changes
end
