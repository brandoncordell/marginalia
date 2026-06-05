# frozen_string_literal: true

# Card component preview
module Ui
  module Card
    # Card component preview
    class ComponentPreview < ApplicationViewComponentPreview
      def default
        render Ui::Card::Component.new do
          'Hello, world!'
        end
      end

      def eyebrow
        render Ui::Card::Component.new(title: 'Eyebrows!') do |component|
          component.with_eyebrow(color: :ink) { 'Hello!' }
          'This is a card with an eyebrow.'
        end
      end

      # @!group Surfaces
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

      def title
        render Ui::Card::Component.new(title: 'Welcome to Your Library') do
          'This is a card with a title.'
        end
      end

      # @param surface "Changes the depth of the card" select { choices: [paper, page, deep, shelf] }
      def playground(surface: :paper)
        render Ui::Card::Component.new(surface: surface.to_sym) do
          'Hello, world!'
        end
      end
    end
  end
end
