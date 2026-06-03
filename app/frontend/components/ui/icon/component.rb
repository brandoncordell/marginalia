# frozen_string_literal: true

# Icon component
module Ui
  module Icon
    # Icon component
    class Component < ApplicationViewComponent
      delegate :lucide_icon, to: :helpers

      option :icon, default: -> {}
      option :size, default: -> { :md }

      def call
        lucide_icon(icon, width: icon_size, height: icon_size)
      end

      private

      def icon_size
        case size
        when :sm
          '16'
        when :lg
          '24'
        else
          '20'
        end
      end
    end
  end
end
