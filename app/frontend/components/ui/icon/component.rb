# frozen_string_literal: true

# Icon component
module Ui
  module Icon
    # Icon component
    class Component < ApplicationViewComponent
      delegate :icon, to: :helpers

      option :name, default: -> {}
      option :size, default: -> { 5 }
      option :classes, default: -> { '' }

      def call
        icon name, variant: :mini, class: "size-#{size} #{classes}"
      end
    end
  end
end
