# frozen_string_literal: true

# Card component
module Ui
  module Card
    # Card component
    class Component < ApplicationViewComponent
      renders_one :eyebrow, Ui::Eyebrow::Component
      renders_one :footer, lambda { |&block|
        content_tag :div, class: 'bg-page-deep px-10 py-4 flex items-center justify-between', &block
      }

      option :title, default: -> {}
      option :surface, default: -> { :paper }

      style do
        base do
          %w[flex flex-col divide-y divide-border-soft rounded-lg border border-border shadow-shelf]
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
