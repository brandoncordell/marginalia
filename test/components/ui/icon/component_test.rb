# frozen_string_literal: true

require 'test_helper'

module Ui
  module Icon
    class ComponentTest < ViewComponent::TestCase
      test 'renders a heroicon svg' do
        render_inline(Component.new(name: 'plus'))

        assert_selector 'svg'
      end

      test 'applies the requested size utility' do
        render_inline(Component.new(name: 'plus', size: 4))

        assert_selector 'svg.size-4'
      end

      test 'appends extra classes' do
        render_inline(Component.new(name: 'plus', classes: '-ml-0.5'))

        assert_selector 'svg[class*="-ml-0.5"]'
      end
    end
  end
end
