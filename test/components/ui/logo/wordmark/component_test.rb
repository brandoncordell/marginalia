# frozen_string_literal: true

require 'test_helper'

module Ui
  module Logo
    module Wordmark
      class ComponentTest < ViewComponent::TestCase
        test 'renders the wordmark svg' do
          render_inline(Component.new)

          assert_selector 'svg'
        end

        test 'defaults to the medium size variant' do
          render_inline(Component.new)

          assert_selector 'svg.h-9.w-auto'
        end

        test 'renders the small size variant' do
          render_inline(Component.new(size: :sm))

          assert_selector 'svg.h-7.w-auto'
        end

        test 'renders the large size variant' do
          render_inline(Component.new(size: :lg))

          assert_selector 'svg.h-10.w-auto'
        end
      end
    end
  end
end
