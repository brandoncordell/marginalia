# frozen_string_literal: true

class ApplicationViewComponent < ViewComponentContrib::Base
  extend Dry::Initializer
  include ViewComponentContrib::StyleVariants

  style_config.postprocess_with do |classes|
    TailwindMerge::Merger.new.merge(classes.join(' '))
  end
end
