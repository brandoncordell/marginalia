# frozen_string_literal: true

require 'test_helper'

module Ui
  module Button
    class ComponentTest < ViewComponent::TestCase
      test 'renders a button with slot content' do
        render_inline(Component.new) { 'Add a book' }

        assert_selector 'button', text: 'Add a book'
      end

      test 'defaults to the primary medium variant' do
        render_inline(Component.new) { 'Save' }

        assert_selector 'button.bg-rust.text-page.px-3.py-2'
      end

      test 'renders the secondary color variant' do
        render_inline(Component.new(color: :secondary)) { 'Cancel' }

        assert_selector 'button.bg-page.text-ink.border-border-soft'
      end

      test 'renders the ghost color variant' do
        render_inline(Component.new(color: :ghost)) { 'Back' }

        assert_selector 'button.bg-transparent.text-ink.border-transparent'
      end

      test 'renders the small size variant' do
        render_inline(Component.new(size: :sm)) { 'Continue' }

        assert_selector 'button[class*="px-2.5"][class*="py-1.5"]'
      end

      test 'renders an icon slot ahead of the label' do
        render_inline(Component.new(color: :primary, size: :sm)) do |button|
          button.with_icon('plus', size: 5)
          'Add a book'
        end

        assert_selector 'button svg'
        assert_text 'Add a book'
      end
    end
  end
end
