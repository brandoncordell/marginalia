# frozen_string_literal: true

require 'test_helper'

module Ui
  module Avatar
    class ComponentPreviewTest < ViewComponent::TestCase
      test 'the default preview renders the sample initials' do
        render_preview(:default, from: Ui::Avatar::ComponentPreview)

        assert_text 'AL'
      end

      test 'the large size preview renders the large variant' do
        render_preview(:lg, from: Ui::Avatar::ComponentPreview)

        assert_selector 'span.size-11'
      end

      test 'the playground preview renders initials from its params' do
        render_preview(:playground, from: Ui::Avatar::ComponentPreview,
                                    params: { first_name: 'grace', last_name: 'hopper' })

        assert_text 'GH'
      end
    end
  end
end
