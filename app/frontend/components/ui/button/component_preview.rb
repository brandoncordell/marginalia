# frozen_string_literal: true

module Ui
  module Button
    # Button component preview
    class ComponentPreview < ApplicationViewComponentPreview
      def default
        render Ui::Button::Component.new do
          'Click me'
        end
      end

      # @!group Colors
      def primary
        render Ui::Button::Component.new(color: :primary) do
          'Click me'
        end
      end

      def secondary
        render Ui::Button::Component.new(color: :secondary) do
          'Click me'
        end
      end

      def ghost
        render Ui::Button::Component.new(color: :ghost) do
          'Click me'
        end
      end
      # @!endgroup

      # @!group Sizes
      def xs
        render Ui::Button::Component.new(size: :xs) do
          'Click me'
        end
      end

      def sm
        render Ui::Button::Component.new(size: :sm) do
          'Click me'
        end
      end

      def md
        render Ui::Button::Component.new(size: :md) do
          'Click me'
        end
      end

      def lg
        render Ui::Button::Component.new(size: :lg) do
          'Click me'
        end
      end
      # @!endgroup

      # @!group Icons
      #
      # Marginalia uses Heroicons for icons, via the `rails_icons` gem.
      #
      # See https://heroicons.com/ and https://github.com/rails/rails_icons
      #
      # @label Icon on xs button
      def icon_xs_primary(name: 'plus')
        render Ui::Button::Component.new(color: :primary, size: :xs) do |button|
          button.with_icon(name)
          'Click me'
        end
      end

      # @label Icon on sm button
      def icon_sm_primary(name: 'plus')
        render Ui::Button::Component.new(color: :primary, size: :sm) do |button|
          button.with_icon(name)
          'Click me'
        end
      end

      # @label Icon on :md button
      def icon_md_primary(name: 'plus')
        render Ui::Button::Component.new(color: :primary, size: :md) do |button|
          button.with_icon(name)
          'Click me'
        end
      end

      # @label Icon on lg button
      def icon_lg_primary(name: 'plus')
        render Ui::Button::Component.new(color: :primary, size: :lg) do |button|
          button.with_icon(name)
          'Click me'
        end
      end
      # @!endgroup

      # @param size select { choices: [sm, md, lg] }
      # @param variant select { choices: [primary, secondary, tertiary] }
      def playground(size: :md, variant: :primary)
        render Ui::Button::Component.new(size: size.to_sym, variant: variant.to_sym) do
          'Click me'
        end
      end
    end
  end
end
