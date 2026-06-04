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
          %w[rounded-lg border border-border-soft p-4]
        end

        variants do
          surface do
            paper { %w[bg-paper] }
            page { %w[bg-page] }
            deep { %w[bg-page-deep] }
            shelf { %w[bg-shelf] }
          end
        end
      end
    end
  end
end
