# frozen_string_literal: true

# Card component preview
module Ui
  module Card
    # Card component preview
    class ComponentPreview < ApplicationViewComponentPreview
      # @label Playground
      # @param surface "Changes the depth of the card" select { choices: [paper, page, deep, shelf] }
      def default(surface: :paper)
        render Ui::Card::Component.new(surface:) do
          'Hello, world!'
        end
      end

      # @!group Surface
      def paper
        render Ui::Card::Component.new(surface: :paper) do
          'Hello, world!'
        end
      end

      def page
        render Ui::Card::Component.new(surface: :page) do
          'Hello, world!'
        end
      end

      def deep
        render Ui::Card::Component.new(surface: :deep) do
          'Hello, world!'
        end
      end

      def shelf
        render Ui::Card::Component.new(surface: :shelf) do
          'Hello, world!'
        end
      end
      # @!endgroup

      # @!group size
      # @!endgroup
    end
  end
end
