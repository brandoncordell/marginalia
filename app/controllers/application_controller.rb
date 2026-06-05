# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication

  allow_browser versions: :modern
  stale_when_importmap_changes

  prepend_before_action :check_setup_state

  private

  def check_setup_state
    redirect_to setup_path if User.none?
  end
end
