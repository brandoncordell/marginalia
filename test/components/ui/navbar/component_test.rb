# frozen_string_literal: true

require 'test_helper'

module Ui
  module Navbar
    class ComponentTest < ViewComponent::TestCase
      include Rails.application.routes.url_helpers

      test 'renders primary navigation and search' do
        render_inline(Component.new)

        assert_selector 'nav'
        assert_text 'Library'
        assert_text 'Shelves'
        assert_text 'Journal'
        assert_selector 'input#search[placeholder="Search title, author, ISBN..."]'
        assert_button 'Add Book'
      end

      test 'renders the app wordmark and name' do
        render_inline(Component.new)

        assert_link href: root_path
        assert_text 'Marginalia'
        assert_selector 'svg'
      end

      test 'omits the user menu when no current user is provided' do
        render_inline(Component.new)

        assert_no_button 'Sign out'
        assert_no_selector "form[action='#{session_path}']"
      end

      test 'renders the signed-in user menu' do
        user = users(:one)

        render_inline(Component.new(current_user: user))

        assert_text user.full_name
        assert_text user.initials
        assert_button 'Sign out'
      end
    end
  end
end
