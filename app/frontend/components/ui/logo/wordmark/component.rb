# frozen_string_literal: true

# Logo wordmark component
module Ui
  module Logo
    module Wordmark
      # Logo wordmark component
      class Component < ApplicationViewComponent
        include ViewComponentContrib::StyleVariants

        option :size, default: -> { :md }

        style do
          variants do
            size do
              sm { %w[h-7 w-auto] }
              md { %w[h-9 w-auto] }
              lg { %w[h-10 w-auto] }
            end
          end
        end
      end
    end
  end
end
