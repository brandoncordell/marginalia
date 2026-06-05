# frozen_string_literal: true

# Card component
module Ui
  module Card
    # Card component
    class Component < ApplicationViewComponent
      include ViewComponentContrib::StyleVariants

      renders_one :eyebrow, Ui::Eyebrow::Component

      option :title, default: -> {}
      option :surface, default: -> { :paper }

      style do
        base do
          %w[flex flex-col rounded-lg border border-border-soft px-10 py-9 gap-4 shadow-shelf]
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
