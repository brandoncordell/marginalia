# frozen_string_literal: true

# Form builder to use View Components and Tailwind classes
class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  TEXT_LIKE_FIELDS = %w[
    text_field
    email_field
    password_field
    number_field
    date_field
    time_field
    datetime_field
    datetime_local_field
  ].freeze

  # Keys consumed by the component (label/adornments), stripped from the options
  # forwarded to the underlying input so they don't leak as HTML attributes.
  COMPONENT_OPTIONS = %i[label leading trailing leading_icon trailing_icon].freeze

  TEXT_LIKE_FIELDS.each do |method|
    define_method(method) do |attribute, **kwargs|
      component = Ui::Form::TextField::Component.new(form: self, attribute:, **kwargs)
      input_html_options = kwargs.except(*COMPONENT_OPTIONS)
                                 .merge(class: component.input_classes, **component.input_aria_attributes)

      @template.render component do
        super(attribute, **input_html_options)
      end
    end
  end
end
