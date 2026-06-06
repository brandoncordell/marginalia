# frozen_string_literal: true

module ApplicationHelper
  # Syntatic sugar for rendering view components
  #
  # @example
  #   component 'top_level', arg: 'Click me'
  #   component 'nested/component', arg: 'Click me' do
  #     <div>Click me</div>
  #   end
  #
  # @param name [String] The name of the component to render
  # @param [Array] The arguments to pass to the component
  # @param [Hash] The keyword arguments to pass to the component
  # @param [Proc] The block to pass to the component
  #
  # @return [String] The rendered component
  def component(name, *, **, &)
    component = name.to_s.camelize.constantize::Component
    render(component.new(*, **), &)
  end
end
