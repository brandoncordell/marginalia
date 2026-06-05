# frozen_string_literal: true

# Navbar component
module Ui
  module Navbar
    # Navbar component
    class Component < ApplicationViewComponent
      option :current_user, default: -> {}
    end
  end
end
