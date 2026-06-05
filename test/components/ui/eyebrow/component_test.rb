# frozen_string_literal: true

require 'test_helper'

module Ui
  module Eyebrow
    class ComponentTest < ViewComponent::TestCase
      test 'renders uppercase eyebrow text' do
        render_inline(Component.new) { 'System check' }

        assert_selector 'span.uppercase', text: 'System check'
      end

      test 'defaults to the ink color variant' do
        render_inline(Component.new) { 'Metadata' }

        assert_selector 'span.text-ink-3'
      end

      test 'renders the rust color variant' do
        render_inline(Component.new(color: :rust)) { 'First-run setup' }

        assert_selector 'span.text-rust', text: 'First-run setup'
      end
    end
  end
end
