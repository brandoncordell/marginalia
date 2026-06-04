# frozen_string_literal: true

# Card component
module Ui
  module Card
    # Card component
    class Component < ApplicationViewComponent
      include ViewComponentContrib::StyleVariants

      option :surface, default: -> { :paper }

      style do
        base do
          %w[rounded-lg border p-4]
        end

        variants do
          surface do
            paper { %w[border-border-soft bg-paper] }
            page { %w[border-border bg-page] }
            deep { %w[border-border bg-page-deep] }
            shelf { %w[border-border bg-shelf] }
          end
        end
      end
    end
  end
end
