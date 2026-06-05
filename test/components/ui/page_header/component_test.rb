# frozen_string_literal: true

require 'test_helper'

module Ui
  module PageHeader
    class ComponentTest < ViewComponent::TestCase
      test 'renders the page title' do
        render_inline(Component.new) { 'Library' }

        assert_selector 'h1.font-display.text-5xl', text: 'Library'
      end
    end
  end
end
