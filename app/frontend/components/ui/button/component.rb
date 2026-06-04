# frozen_string_literal: true

# Button component
module Ui
  module Button
    # Button component
    class Component < ApplicationViewComponent
      include ViewComponentContrib::StyleVariants

      option :color, default: -> { :primary }
      option :size, default: -> { :md }

      renders_one :icon, lambda { |name, size: 5|
        Ui::Icon::Component.new(name:, size:, classes: '-ml-0.5')
      }

      style do
        base do
          %w[inline-flex items-center text-semibold rounded-md border cursor-pointer
             whitespace-nowrap text-sm]
        end

        variants do
          color do
            primary { %w[bg-rust text-page border-rust hover:bg-rust-hover active:bg-rust-press] }
            secondary { %w[bg-page text-ink border-border-soft hover:bg-ink hover:text-page] }
            ghost { %w[bg-transparent text-ink border-transparent hover:bg-paper] }
          end

          size do
            xs { %w[gap-x-1 px-2 py-1] }
            sm { %w[gap-x-1.5 px-2.5 py-1.5] }
            md { %w[gap-x-1.5 px-3 py-2] }
            lg { %w[gap-x-2 px-3.5 py-2.5] }
          end
        end
      end
    end
  end
end
