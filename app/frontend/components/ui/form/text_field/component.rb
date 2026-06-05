# frozen_string_literal: true

# Text field component
module Ui
  module Form
    module TextField
      # Text field component
      class Component < ApplicationViewComponent
        option :form, default: -> {}
        option :name, default: -> {}
        option :placeholder, default: -> {}
        option :type, default: -> { :text }
        option :value, default: -> {}
      end
    end
  end
end
