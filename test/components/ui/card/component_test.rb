# frozen_string_literal: true

require 'test_helper'

module Ui
  module Card
    class ComponentTest < ViewComponent::TestCase
      test 'renders the title and body content' do
        render_inline(Component.new(title: 'Welcome')) { 'Body copy' }

        assert_selector 'h2', text: 'Welcome'
        assert_text 'Body copy'
      end

      test 'renders without a title when none is given' do
        render_inline(Component.new) { 'Body only' }

        assert_no_selector 'h2'
        assert_text 'Body only'
      end

      test 'renders an eyebrow slot above the title' do
        render_inline(Component.new(title: 'Welcome')) do |card|
          card.with_eyebrow(color: :rust) { 'First-run setup' }
        end

        assert_selector 'span.uppercase', text: 'First-run setup'
        assert_selector 'h2', text: 'Welcome'
      end

      test 'renders the page surface variant' do
        render_inline(Component.new(title: 'Settings', surface: :page)) { 'Details' }

        assert_selector 'div.bg-page'
      end
    end
  end
end
