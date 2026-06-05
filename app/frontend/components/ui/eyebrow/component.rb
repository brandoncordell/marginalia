# frozen_string_literal: true

# Eyebrow component
module Ui
  module Eyebrow
    # Eyebrow component
    class Component < ApplicationViewComponent
      option :color, default: -> { :ink }

      erb_template <<-ERB
        <span class="<%= style(color:) %> font-sans font-medium text-xs tracking-wide uppercase">
          <%= content %>
        </span>
      ERB

      style do
        variants do
          color do
            ink { %w[text-ink-3] }
            moss { %w[text-moss] }
            foxing { %w[text-foxing] }
            rust { %w[text-rust] }
          end
        end
      end
    end
  end
end
