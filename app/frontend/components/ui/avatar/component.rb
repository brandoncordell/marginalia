# frozen_string_literal: true

# Avatar component
module Ui
  module Avatar
    # Renders a user's initials inside a circular badge.
    class Component < ApplicationViewComponent
      option :user
      option :size, default: -> { :md }

      delegate :initials, :full_name, to: :user

      style do
        base do
          %w[inline-flex items-center justify-center shrink-0 rounded-full bg-moss text-page
             font-medium uppercase select-none]
        end

        variants do
          size do
            sm { %w[size-7 text-xs] }
            md { %w[size-9 text-sm] }
            lg { %w[size-11 text-base] }
          end
        end
      end
    end
  end
end
