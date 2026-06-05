# frozen_string_literal: true

module Onboarding
  # Import step controller for the onboarding wizard.
  class ImportsController < BaseController
    STEP = 'import'

    def show; end

    def update
      if !params[:skip] && params.dig(:setting, :goodreads_csv).present?
        # TODO: ImportGoodreadsJob.perform_later(stored_path_for(file))
      end

      advance_and_redirect!
    end
  end
end
