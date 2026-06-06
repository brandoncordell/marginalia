# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  # Stand-in for a ViewComponent. It records the arguments it was built with so
  # the tests can assert the helper forwarded them to `.new` untouched — no real
  # components are involved.
  class MockComponent
    attr_reader :args, :kwargs

    def initialize(*args, **kwargs)
      @args = args
      @kwargs = kwargs
    end
  end

  # Distinct subclasses let the tests prove the helper resolved the *correct*
  # constant for each name, not merely "some component".
  class TopLevelMockComponent < MockComponent; end
  class NestedMockComponent < MockComponent; end

  setup do
    # The helper resolves `name.to_s.camelize.constantize::Component`, which needs
    # real constants to exist. Define throwaway ones: a top-level `Test` namespace
    # and a nested `Ui::Form::Button` (under the app's existing `Ui::Form`).
    Object.const_set(:Test, Module.new)
    Test.const_set(:Component, TopLevelMockComponent)

    Ui::Form.const_set(:Button, Module.new)
    Ui::Form::Button.const_set(:Component, NestedMockComponent)
  end

  teardown do
    Object.send(:remove_const, :Test)
    Ui::Form.send(:remove_const, :Button)
  end

  # The helper calls a bare `render`, which dispatches to this test instance
  # (ActionView::TestCase mixes the helper in via `include _helpers`). Overriding
  # `render` as a singleton method here mocks it for a single test — the captured
  # value is the component the helper handed to `render`.
  def capture_render(&)
    captured = {}
    define_singleton_method(:render) do |component, &block|
      captured[:component] = component
      captured[:block] = block
      :rendered_markup
    end
    captured[:result] = instance_exec(&)
    captured
  end

  test "resolves a top-level namespace ('test' -> Test::Component) and renders it" do
    rendered = capture_render { component('test', arg: 'one') }

    assert_instance_of TopLevelMockComponent, rendered[:component]
    assert_equal({ arg: 'one' }, rendered[:component].kwargs)
  end

  test "resolves a nested namespace ('ui/form/button' -> Ui::Form::Button::Component) and renders it" do
    rendered = capture_render { component('ui/form/button', arg: 'one') }

    assert_instance_of NestedMockComponent, rendered[:component]
    assert_equal({ arg: 'one' }, rendered[:component].kwargs)
  end

  test 'forwards positional arguments to the component' do
    rendered = capture_render { component('test', 'one', 'two', key: 'value') }

    assert_equal %w[one two], rendered[:component].args
    assert_equal({ key: 'value' }, rendered[:component].kwargs)
  end

  test 'forwards a block to render' do
    given_block = proc { 'body' }
    rendered = capture_render { component('test', &given_block) }

    assert_same given_block, rendered[:block]
  end

  test 'returns the value produced by render' do
    rendered = capture_render { component('test', arg: 'one') }

    assert_equal :rendered_markup, rendered[:result]
  end
end
