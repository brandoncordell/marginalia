# frozen_string_literal: true

# Onboarding Wizard Step component
module Onboarding
  module Wizard
    module Step
      # Step component
      class Component < ApplicationViewComponent
        option :index, default: -> { 0 }
        option :step, default: -> { '' }
        option :status, default: -> { :pending }

        delegate :icon, to: :helpers

        erb_template <<-ERB
          <div class="flex flex-col items-center gap-2 min-w-12">
            <span class="<%= style(status:) %>">
              <% if status == :complete %>
                <%= icon 'check', class: 'size-4', stroke_width: 2 %>
              <% else %>
                <%= index + 1 %>
              <% end %>
            </span>

            <span class="font-sans text-xxs text-center font-semibold text-ink">
              <%= step %>
            </span>
          </div>
        ERB

        style do
          base do
            'w-[30px] h-[30px] rounded-full inline-flex items-center justify-center font-mono text-[12.5px] font-semibold shrink-0 border-solid leading-none' # rubocop:disable Layout/LineLength
          end

          variants do
            status do
              active { %w[bg-page text-rust border-2 border-rust] }
              complete { %w(bg-rust text-page border-[1.5px] border-rust) }
              pending { %w(bg-paper text-ink-4 border-[1.5px] border-border) }
            end
          end
        end
      end
    end
  end
end
