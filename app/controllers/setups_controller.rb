# frozen_string_literal: true

# Setup controller
class SetupsController < ApplicationController
  allow_unauthenticated_access
  before_action :redirect_if_configured
  skip_before_action :check_setup_state

  def show
    @user = User.new
  end

  private

  def redirect_if_configured
    redirect_to root_path if User.any?
  end
end
