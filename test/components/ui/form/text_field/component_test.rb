# frozen_string_literal: true

require 'test_helper'
require 'capybara'

module Ui
  module Form
    module TextField
      # Adornments are applied through TailwindFormBuilder (which computes the
      # input's padding classes and renders the real input), so the tests drive
      # the field through the builder — the actual usage path.
      class ComponentTest < ActionView::TestCase
        class TestRecord
          include ActiveModel::Model
          include ActiveModel::Attributes

          attribute :email, :string
          attribute :amount, :string
        end

        def build_form(record = TestRecord.new)
          TailwindFormBuilder.new(:record, record, view, {})
        end

        def render_field(attribute = :email, record: TestRecord.new, **options)
          Capybara.string(build_form(record).text_field(attribute, **options))
        end

        test "labels the input by its attribute so label's for matches the input id" do
          field = render_field(:email)

          assert_equal 'record_email', field.find('label')[:for]
          assert_equal 'record_email', field.find('input')[:id]
          assert field.has_selector?('label', text: 'Email')
        end

        test 'leading_icon renders a leading icon and reserves left padding' do
          field = render_field(:email, leading_icon: 'envelope')

          assert field.has_selector?('div.pointer-events-none.absolute.left-0 svg'), 'expected a leading icon'
          assert field.has_selector?('input[class*="pl-10"]')
          assert field.has_selector?('input[class*="pr-3"]')
        end

        test 'trailing_icon renders a trailing icon and reserves right padding' do
          field = render_field(:email, trailing_icon: 'check')

          assert field.has_selector?('div.absolute.right-0 svg'), 'expected a trailing icon'
          assert field.has_selector?('input[class*="pr-10"]')
          assert field.has_selector?('input[class*="pl-3"]')
        end

        test 'renders both leading and trailing adornments together' do
          field = render_field(:email, leading_icon: 'envelope', trailing_icon: 'check')

          assert field.has_selector?('div.left-0 svg')
          assert field.has_selector?('div.right-0 svg')
          assert field.has_selector?('input[class*="pl-10"][class*="pr-10"]')
        end

        test 'accepts an arbitrary element as a leading adornment' do
          field = render_field(:amount, leading: view.tag.span('$', class: 'unit'))

          assert field.has_selector?('div.left-0 span.unit', text: '$')
          assert field.has_selector?('input[class*="pl-10"]')
        end

        test 'does not leak component options onto the input element' do
          field = render_field(:email, label: 'Email address', leading_icon: 'envelope',
                                       placeholder: 'you@example.com')
          input = field.find('input')

          assert_equal 'you@example.com', input[:placeholder]
          assert_nil input[:label]
          assert_nil input[:leading_icon]
        end

        test 'composes error styling with adornments' do
          record = TestRecord.new
          record.errors.add(:email, 'is invalid')

          field = render_field(:email, record:, trailing_icon: 'exclamation-circle')

          assert field.has_selector?('input[class*="outline-rust"]')
          assert field.has_selector?('div.right-0 svg')
        end

        test 'renders validation messages and links them to the input' do
          record = TestRecord.new
          record.errors.add(:email, 'is invalid')

          field = render_field(:email, record:)
          input = field.find('input')

          assert field.has_selector?('#record_email_error', text: 'Email is invalid')
          assert_equal 'record_email_error', input['aria-describedby']
          assert_equal 'true', input['aria-invalid']
        end

        test 'renders no error container or aria attributes when valid' do
          field = render_field(:email)
          input = field.find('input')

          assert_not field.has_selector?('#record_email_error')
          assert_nil input['aria-describedby']
          assert_nil input['aria-invalid']
        end
      end
    end
  end
end
