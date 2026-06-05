# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include Onboardable

  allow_browser versions: :modern
  stale_when_importmap_changes
end
