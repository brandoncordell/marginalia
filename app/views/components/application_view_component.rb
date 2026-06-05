# frozen_string_literal: true

class ApplicationViewComponent < ViewComponentContrib::Base
  extend Dry::Initializer
  include ViewComponentContrib::StyleVariants
end
