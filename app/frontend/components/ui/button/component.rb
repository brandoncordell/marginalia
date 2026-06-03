# frozen_string_literal: true

# Button component
module Ui
  module Button
    # Button component
    class Component < ApplicationViewComponent
      include ViewComponentContrib::StyleVariants

      option :color, default: -> { :primary }
      option :size, default: -> { :md }

      renders_one :icon, lambda { |icon, size:|
        Ui::Icon::Component.new(icon:, size:)
      }

      style do
        base do
          %w[inline-flex items-center gap-2 text-semibold rounded-md border border-transparent cursor-pointer
             whitespace-nowrap]
        end

        variants do
          color do
            primary { %w[bg-rust text-page border border-rust] }
          end

          size do
            sm { %w[text-[13px] px-3 py-[7px]] }
            md { %w[text-[14px] px-4 py-2.5] }
            lg { %w[text-[15px] px-5 py-3] }
          end
        end
      end
    end
  end
end
