# frozen_string_literal: true

module Ui
  module Form
    module TextField
      # Text field component
      class Component < ApplicationViewComponent
        def initialize(form:, attribute:, **options)
          @form = form
          @attribute = attribute
          @label = options.delete(:label) { attribute.to_s.humanize }
          @leading = resolve_adornment(options, :leading, :leading_icon)
          @trailing = resolve_adornment(options, :trailing, :trailing_icon)
        end

        def leading? = @leading.present?
        def trailing? = @trailing.present?

        # Tailwind classes
        def input_classes
          class_names(
            %w(block w-full rounded-md py-1.5 text-sm text-ink outline-1 -outline-offset-1 outline-border transition-[outline-color,box-shadow] duration-quick ease-shelf focus:outline-2 focus:-outline-offset-2 focus:outline-rust focus:shadow-[0_0_0_3px_var(--focus-ring)]),
            {
              # Reserve room for adornments. pl/pr are mutually exclusive per side so
              # they don't conflict (class_names concatenates; it isn't TailwindMerge'd).
              "pl-3": !leading?, "pl-10": leading?,
              "pr-3": !trailing?, "pr-10": trailing?,
              "border-rust outline-rust shadow-[0_0_0_3px_var(--focus-ring)] text-rust": has_errors?,
            }
          )
        end

        def label_classes
          %w[block font-sans text-sm font-semibold text-ink-2 tracking-wide]
        end

        # Error handling
        def error_messages
          return [] unless has_errors?

          @form.object.errors.full_messages_for(@attribute)
        end

        def has_errors?
          # form_with without a model yields `false` (not nil) for #object, so a
          # plain `&.` chain isn't enough to guard model-less forms.
          @form.object.respond_to?(:errors) && @form.object.errors.include?(@attribute)
        end

        # Id of the error container, matching how Rails derives field ids so it can
        # be referenced from the input's aria-describedby.
        def error_message_id
          @form.field_id(@attribute, "error")
        end

        def error_classes
          %w[mt-2 text-sm text-rust]
        end

        # Accessibility attributes merged onto the input when the field is invalid.
        def input_aria_attributes
          return {} unless has_errors?

          { aria: { invalid: true, describedby: error_message_id } }
        end

        private

        # Resolve an adornment from the options: an explicit element passed via
        # `leading:`/`trailing:` (a component instance, proc, or safe HTML string),
        # or an icon name via `leading_icon:`/`trailing_icon:`. Both keys are
        # removed from options so they don't leak onto the input.
        def resolve_adornment(options, element_key, icon_key)
          if (element = options.delete(element_key))
            element
          elsif (name = options.delete(icon_key))
            Ui::Icon::Component.new(name:, classes: "text-ink-3")
          end
        end

        def render_adornment(adornment)
          if adornment.respond_to?(:render_in)
            render(adornment)
          elsif adornment.respond_to?(:call)
            adornment.call
          else
            adornment
          end
        end
      end
    end
  end
end
