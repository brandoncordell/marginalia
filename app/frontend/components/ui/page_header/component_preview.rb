# frozen_string_literal: true

module Ui
  module PageHeader
    # Page title component preview
    class ComponentPreview < ApplicationViewComponentPreview
      # Default page title
      def default
        render Ui::PageHeader::Component.new do
          'Page Title'
        end
      end
    end
  end
end
