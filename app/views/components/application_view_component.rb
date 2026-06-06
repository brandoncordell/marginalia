# frozen_string_literal: true

class ApplicationViewComponent < ViewComponentContrib::Base
  extend Dry::Initializer
  include ViewComponentContrib::StyleVariants

  # Allow components to render nested components with the `component` view helper,
  # just like templates do (mirrors how Ui::Icon delegates `icon` to helpers).
  delegate :component, to: :helpers

  style_config.postprocess_with do |classes|
    TailwindMerge::Merger.new.merge(classes.join(' '))
  end
end
