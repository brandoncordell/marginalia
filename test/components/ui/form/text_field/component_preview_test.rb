# frozen_string_literal: true

require 'test_helper'

module Ui
  module Form
    module TextField
      class ComponentPreviewTest < ViewComponent::TestCase
        test 'the default preview renders a labelled input' do
          render_preview(:default, from: Ui::Form::TextField::ComponentPreview)

          assert_selector 'label', text: 'Email'
          assert_selector 'input#user_email'
        end

        test 'the leading_icon preview renders a leading icon' do
          render_preview(:leading_icon, from: Ui::Form::TextField::ComponentPreview)

          assert_selector 'div.pointer-events-none.left-0 svg'
          assert_selector 'input[class*="pl-10"]'
        end

        test 'the trailing_icon preview renders a trailing icon' do
          render_preview(:trailing_icon, from: Ui::Form::TextField::ComponentPreview)

          assert_selector 'div.right-0 svg'
          assert_selector 'input[class*="pr-10"]'
        end

        test 'the leading_and_trailing preview renders both adornments' do
          render_preview(:leading_and_trailing, from: Ui::Form::TextField::ComponentPreview)

          assert_selector 'div.left-0 svg'
          assert_selector 'div.right-0 svg'
          assert_selector 'input[class*="pl-10"][class*="pr-10"]'
        end

        test 'the elements preview renders arbitrary leading and trailing elements' do
          render_preview(:elements, from: Ui::Form::TextField::ComponentPreview)

          assert_selector 'div.left-0 span', text: '$'
          assert_selector 'div.right-0 span', text: 'USD'
        end

        test 'the with_errors preview renders the validation message' do
          render_preview(:with_errors, from: Ui::Form::TextField::ComponentPreview)

          assert_selector '#user_first_name_error.text-rust', text: "can't be blank"
          assert_selector 'input[aria-describedby="user_first_name_error"][aria-invalid="true"]'
        end
      end
    end
  end
end
