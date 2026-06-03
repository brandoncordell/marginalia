# frozen_string_literal: true

require 'test_helper'

module Ui
  module Avatar
    class ComponentTest < ViewComponent::TestCase
      test 'renders the user initials' do
        render_inline(Ui::Avatar::Component.new(user: users(:one)))

        assert_text 'AL'
      end

      test 'reflects the initials logic for a built (unsaved) user' do
        render_inline(Ui::Avatar::Component.new(user: User.new(first_name: 'grace', last_name: 'hopper')))

        assert_text 'GH'
      end

      test 'exposes the full name for accessibility' do
        render_inline(Ui::Avatar::Component.new(user: users(:one)))

        assert_selector "[role='img'][title='Ada Lovelace'][aria-label='Ada Lovelace']"
      end

      test 'defaults to the medium size variant' do
        render_inline(Ui::Avatar::Component.new(user: users(:one)))

        assert_selector 'span.size-9.text-sm'
      end

      test 'renders the small size variant' do
        render_inline(Ui::Avatar::Component.new(user: users(:one), size: :sm))

        assert_selector 'span.size-7.text-xs', text: 'AL'
      end

      test 'renders the large size variant' do
        render_inline(Ui::Avatar::Component.new(user: users(:one), size: :lg))

        assert_selector 'span.size-11.text-base'
      end
    end
  end
end
