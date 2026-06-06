# frozen_string_literal: true

module Ui
  module Form
    module TextField
      # Text field component preview
      class ComponentPreview < ApplicationViewComponentPreview
        # A labelled text field rendered through the TailwindFormBuilder.
        def default; end

        # @!group Adornments

        # A decorative, non-interactive leading icon.
        def leading_icon; end

        # A trailing icon.
        def trailing_icon; end

        # Both a leading and a trailing icon.
        def leading_and_trailing; end

        # Arbitrary elements instead of icons (a currency prefix and unit suffix).
        def elements; end

        # @!endgroup

        # An invalid field showing its validation message.
        def with_errors; end
      end
    end
  end
end
