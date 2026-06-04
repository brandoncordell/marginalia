# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication

  allow_browser versions: :modern # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  stale_when_importmap_changes # Changes to the importmap will invalidate the etag for HTML responses

  before_action :check_setup_state

  private

  def check_setup_state
    return unless User.none?

    redirect_to setup_path
  end
end
